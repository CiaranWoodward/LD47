extends Node2D

var item = Global.ItemType.NONE setget _set_item
var instance : Node2D
var itemvis : Node2D
var direction : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_item(item)

func _set_item(newitem):
	item = newitem
	if is_instance_valid(itemvis):
		itemvis.queue_free()
	itemvis = Global.instance_item(item)
	if is_instance_valid(itemvis):
		self.add_child(itemvis)
	if newitem == Global.ItemType.MACHINE:
		$DropTile.visible = true
	else:
		$DropTile.visible = false
	_set_rotation()

func _snap_to_tile():
	position = get_parent().tile_to_world_coords(get_parent().world_to_tile_coords(position))

func _tile_free(tc):
	if get_parent().get_tile(tc) != null:
		return false
	if !get_parent().is_tc_on_map(tc):
		return false
	return true

func _can_place():
	var tc = get_parent().world_to_tile_coords(position)
	if item == Global.ItemType.MACHINE:
		return _tile_free(tc) && _tile_free(tc + Global.get_dir_vec(direction))
	else:
		return _tile_free(tc)

func _set_rotation():
	if !is_instance_valid(itemvis):
		return
	if item == Global.ItemType.ARROW_PLATE:
		itemvis.rotation = (PI/2) * direction
	elif item == Global.ItemType.MACHINE:
		$DropTile.position = get_parent().TILE_SIZE * Global.get_dir_vec(direction)
	else:
		itemvis.rotation = 0

func _rotate():
	direction = (direction + 1) % 4
	_set_rotation()

func _unhandled_input(event):
	if event is InputEventMouse:
		set_global_position(get_global_mouse_position())
		_snap_to_tile()
		if _can_place():
			self.modulate = Color(1, 1, 1, 0.5)
		else:
			self.modulate = Color(1, 1, 1, 0)
			return
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT):
		if event.is_pressed():
			instance.position = position
			get_parent().add_child(instance)
			Set(null)
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			Global.deposit_item(item)
			Set(null)
	if event.is_action_released("rotate"):
		_rotate()

func Set(iteminstance):
	if !is_instance_valid(iteminstance):
		_set_item(Global.ItemType.NONE)
	_set_item(iteminstance.item_id)
	instance = iteminstance
