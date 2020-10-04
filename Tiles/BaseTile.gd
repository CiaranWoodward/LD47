tool
extends StaticBody2D

# Called when the node enters the scene tree
func _ready():
	if get_parent().has_method("reg_tile"):
		get_parent().reg_tile(self)

func GetTileCoords():
	return get_parent().world_to_tile_coords(get_position())

func SnapToGrid():
	if get_parent().has_method("tile_to_world_coords"):
		set_position(get_parent().tile_to_world_coords(GetTileCoords()))

func _process(_delta):
	if Engine.editor_hint:
		SnapToGrid()
