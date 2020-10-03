extends KinematicBody2D

enum State {STOPPED, WORKING, MOVING, STOPPING}

export var MAX_SPEED : float = 120.0
export var ACCEL_TIME : float = 1.5
export(Global.TransitionType) var ACCEL_TRANS = Tween.TRANS_ELASTIC
export(Global.EaseType) var ACCEL_EASE = Tween.EASE_IN_OUT
export var STOP_TIME : float = 1
export(Global.TransitionType) var STOP_TRANS = Tween.TRANS_BOUNCE
export(Global.EaseType) var STOP_EASE = Tween.EASE_IN

onready var tweener = get_node("MoveTweener")

var cur_state = State.STOPPED
var cur_direction = Vector2(0, 0)
var cur_speed : float = 0

var cur_item = Global.ItemType.NONE
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	SnapToGrid()

func GetTileCoords():
	return get_parent().WorldToTileCoords(get_position())

func SnapToGrid():
	set_position(get_parent().TileToWorldCoords(GetTileCoords()))

func _hasItem():
	return (cur_item != Global.ItemType.NONE)

func _speed_up():
	tweener.interpolate_property(self, "cur_speed", cur_speed, MAX_SPEED, ACCEL_TIME, ACCEL_TRANS, ACCEL_EASE)
	tweener.start()

func _handle_stopped():
	var curTile = get_parent().GetTile(GetTileCoords())
	if !is_instance_valid(curTile):
		return
	if curTile.has_method("GetPushVec"):
		cur_direction = curTile.GetPushVec()
		if cur_direction != Vector2.ZERO:
			cur_state = State.MOVING
			get_node("AnimationPlayer").play("Walk")
			_speed_up()

func _handle_stopping():
	var targetPos = get_parent().TileToWorldCoords(GetTileCoords())
	cur_state = State.STOPPING
	cur_speed = 0
	tweener.remove_all();
	tweener.interpolate_property(self, "position", position, targetPos, STOP_TIME, STOP_TRANS, STOP_EASE)
	tweener.start()
	get_node("AnimationPlayer").stop(false)

func _handle_collision(kc : KinematicCollision2D):
	var target = kc.collider
	var shouldStop = false
	
	if _hasItem() && cur_state == State.MOVING && target.has_method("GiveItem") && target.GiveItem(cur_item):
		cur_item = Global.ItemType.NONE
		if is_instance_valid(cur_itemvis):
			cur_itemvis.queue_free()
			cur_itemvis = null
		shouldStop = true
	elif !_hasItem() && target.has_method("TakeItem") && cur_state == State.MOVING:
		cur_item = target.TakeItem()
		cur_itemvis = Global.instance_item(cur_item)
		if is_instance_valid(cur_itemvis):
			self.add_child(cur_itemvis)
		shouldStop = true
	if target.has_method("IsStopper") && target.IsStopper():
		shouldStop = true
		
	if shouldStop:
		_handle_stopping()

func _physics_process(delta):
	match cur_state:
		State.STOPPED:
			_handle_stopped()
		State.WORKING:
			pass
		State.MOVING:
			var kc = self.move_and_collide(cur_direction * cur_speed * delta)
			if is_instance_valid(kc):
				_handle_collision(kc)


func _on_MoveTweener_tween_all_completed():
	match cur_state:
		State.STOPPING:
			cur_state = State.STOPPED
