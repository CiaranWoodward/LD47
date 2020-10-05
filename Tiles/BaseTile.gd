tool
extends StaticBody2D

var player_built : bool = false setget _setplayerbuilt
var item_id : int = Global.ItemType.NONE
var deconstructable = false

# Called when the node enters the scene tree
func _ready():
	if get_parent().has_method("reg_tile"):
		get_parent().reg_tile(self)
	if !Engine.editor_hint:
		self.connect("input_event", self, "_on_input_event")
		self.connect("mouse_entered", self, "_on_mouse_enter")
		self.connect("mouse_exited", self, "_on_mouse_exit")
		Global.connect("deconstruct_mode_changed", self, "_on_deconstruct_mode_changed")

func _exit_tree():
	request_ready()
	Global.deposit_item(item_id)

func _setplayerbuilt(newval):
	player_built = newval
	self.input_pickable = newval

func GetTileCoords():
	return get_parent().world_to_tile_coords(get_position())

func SnapToGrid():
	if get_parent().has_method("tile_to_world_coords"):
		set_position(get_parent().tile_to_world_coords(GetTileCoords()))

func _process(_delta):
	if Engine.editor_hint:
		SnapToGrid()

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
			self.queue_free()

func _on_deconstruct_mode_changed(enabled : bool):
	if !player_built:
		return
	deconstructable = enabled
	if enabled:
		modulate = Color(1, 0.6, 0.6, 1)
	else:
		modulate = Color(1, 1, 1, 1)
