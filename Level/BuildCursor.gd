extends Node2D

var item = Global.ItemType.WALLS setget _set_item
var itemvis : Node2D

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

func _snap_to_tile():
	position = get_parent().tile_to_world_coords(get_parent().world_to_tile_coords(position))

func _can_place():
	var tc = get_parent().world_to_tile_coords(position)
	if get_parent().get_tile(tc) != null:
		return false
	if !get_parent().is_tc_on_map(tc):
		return false
	return true

func _unhandled_input(event):
	if event is InputEventMouse:
		set_global_position(get_global_mouse_position())
		_snap_to_tile()
		if _can_place():
			self.modulate = Color(1, 1, 1, 1)
		else:
			self.modulate = Color(1, 1, 1, 0)
			return
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT):
		if event.is_pressed():
			#place
			pass
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			#cancel
			pass
