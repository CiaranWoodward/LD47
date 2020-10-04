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
onready var animator = get_node("AnimationPlayer")
onready var sprites = get_node("Robo")

var cur_state = State.STOPPED
var cur_direction = Vector2(0, 0)
var cur_speed : float = 0

var cur_item = Global.ItemType.NONE
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	SnapToGrid()

func GetTileCoords():
	return get_parent().world_to_tile_coords(get_position())

func SnapToGrid():
	set_position(get_parent().tile_to_world_coords(GetTileCoords()))

func _hasItem():
	return (cur_item != Global.ItemType.NONE)

func _speed_up():
	tweener.interpolate_property(self, "cur_speed", cur_speed, MAX_SPEED, ACCEL_TIME, ACCEL_TRANS, ACCEL_EASE)
	tweener.start()

func _handle_startmove():
	cur_state = State.MOVING
	_speed_up()
	if cur_direction.x != 0:
		animator.play("SideWalk")
		sprites.get_node("Side").visible = true
		sprites.get_node("Front").visible = false
		sprites.get_node("Back").visible = false
		if cur_direction.x > 0:
			sprites.scale.x = abs(sprites.scale.x)
		else:
			sprites.scale.x = abs(sprites.scale.x) * -1
	if cur_direction.y != 0:
		animator.play("Walk")
		sprites.scale.x = abs(sprites.scale.x)
		sprites.get_node("Side").visible = false
		if cur_direction.y > 0:
			sprites.get_node("Front").visible = true
			sprites.get_node("Back").visible = false
		else:
			sprites.get_node("Front").visible = false
			sprites.get_node("Back").visible = true

func _handle_stopped():
	var curTile = get_parent().get_tile(GetTileCoords())
	if !is_instance_valid(curTile):
		return
	if curTile.has_method("GetPushVec"):
		cur_direction = curTile.GetPushVec()
		if cur_direction != Vector2.ZERO:
			_handle_startmove()

func _handle_stopping():
	var targetPos = get_parent().tile_to_world_coords(GetTileCoords())
	cur_state = State.STOPPING
	cur_speed = 0
	tweener.remove_all();
	tweener.interpolate_property(self, "position", position, targetPos, STOP_TIME, STOP_TRANS, STOP_EASE)
	tweener.start()
	animator.stop(false)

func _handle_armsup(armsup : bool):
	if armsup:
		sprites.get_node("Back/ArmsDown").visible = false
		sprites.get_node("Front/ArmsDown").visible = false
		sprites.get_node("Side/SideArmsDown").visible = false
		sprites.get_node("Back/ArmsUp").visible = true
		sprites.get_node("Front/ArmsUp").visible = true
		sprites.get_node("Side/SideArmsUp").visible = true
	else:
		sprites.get_node("Back/ArmsDown").visible = true
		sprites.get_node("Front/ArmsDown").visible = true
		sprites.get_node("Side/SideArmsDown").visible = true
		sprites.get_node("Back/ArmsUp").visible = false
		sprites.get_node("Front/ArmsUp").visible = false
		sprites.get_node("Side/SideArmsUp").visible = false

func _handle_collision(kc : KinematicCollision2D):
	var target = kc.collider
	var shouldStop = false
	
	if _hasItem() && cur_state == State.MOVING && target.has_method("GiveItem") && target.GiveItem(cur_item):
		cur_item = Global.ItemType.NONE
		if is_instance_valid(cur_itemvis):
			cur_itemvis.queue_free()
			cur_itemvis = null
		shouldStop = true
		_handle_armsup(false)
	elif !_hasItem() && target.has_method("TakeItem") && cur_state == State.MOVING:
		cur_item = target.TakeItem()
		cur_itemvis = Global.instance_item(cur_item)
		if is_instance_valid(cur_itemvis):
			self.add_child(cur_itemvis)
		shouldStop = true
		_handle_armsup(true)
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
