extends KinematicBody2D

enum State {STOPPED, WORKING, MOVING, STOPPING}
tool

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
var offloading = false
var deconstructable = false

var item_id = Global.ItemType.ROBO

# Called when the node enters the scene tree for the first time.
func _ready():
	if offloading:
		return
	SnapToGrid()
	_set_collision()
	if !Engine.editor_hint:
		self.connect("input_event", self, "_on_input_event")
		self.connect("mouse_entered", self, "_on_mouse_enter")
		self.connect("mouse_exited", self, "_on_mouse_exit")
		Global.connect("deconstruct_mode_changed", self, "_on_deconstruct_mode_changed")

func GetTileCoords():
	return get_parent().world_to_tile_coords(get_position())

func SnapToGrid():
	if get_parent().has_method("tile_to_world_coords"):
		set_position(get_parent().tile_to_world_coords(GetTileCoords()))

func GetCurItem():
	return cur_item

func Stop():
	_handle_stopping()

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
	if curTile.has_method("Use"):
		curTile.Use()

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
		if cur_item != Global.ItemType.NONE:
			cur_itemvis = Global.instance_item(cur_item)
			if is_instance_valid(cur_itemvis):
				$"Robo/ItemPoint".add_child(cur_itemvis)
			shouldStop = true
			_handle_armsup(true)
	elif !_hasItem() && target.has_method("GiveSelf") && cur_state == State.MOVING:
		if target.GiveSelf(cur_direction, self):
			# Bai world
			offloading = true
			return
	if target.has_method("IsStopper"):
		if target.IsStopper(cur_item):
			shouldStop = true
	
	_set_collision()
	if shouldStop:
		_handle_stopping()

func _set_collision():
	if cur_item == Global.ItemType.NONE:
		collision_layer = Global.PhyLayer.ROBO + Global.PhyLayer.EMPTY_ROBO
		collision_mask = Global.PhyLayer.ROBO + Global.PhyLayer.EMPTY_ROBO
	else:
		collision_layer = Global.PhyLayer.ROBO + Global.PhyLayer.FULL_ROBO
		collision_mask = Global.PhyLayer.ROBO + Global.PhyLayer.FULL_ROBO

func _process(_delta):
	if Engine.editor_hint:
		SnapToGrid()

func _physics_process(delta):
	if Engine.editor_hint || offloading:
		return
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

func _on_mouse_enter():
	if !deconstructable:
		return
	modulate = Color(1, 0.4, 0.4, 1)

func _on_mouse_exit():
	if !deconstructable:
		return
	modulate = Color(1, 0.6, 0.6, 1)

func _on_input_event(node, event, shape_idx):
	if !deconstructable:
		return
	if event is InputEventMouseMotion:
		modulate = Color(1, 0.4, 0.4, 1)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			Global.deposit_item(Global.ItemType.ROBO)
			self.queue_free()

func _on_deconstruct_mode_changed(enabled : bool):
	deconstructable = enabled
	if enabled:
		modulate = Color(1, 0.6, 0.6, 1)
	else:
		modulate = Color(1, 1, 1, 1)
