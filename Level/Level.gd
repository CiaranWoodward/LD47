tool
extends YSort

# Tile size in pixels
const TILE_SIZE = 75
const floorTile = preload("res://Tiles/FloorTile.tscn")

export var LEVEL_SIZE_X : int = 10
export var LEVEL_SIZE_Y : int = 10

var MapDict = {}
var built_tiles = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(LEVEL_SIZE_X):
		for y in range(LEVEL_SIZE_Y):
			var newTile = floorTile.instance()
			newTile.position = tile_to_world_coords(Vector2(x, y))
			$Floor.add_child(newTile)
	if !Engine.editor_hint:
		$MainCam.MaxPos = Vector2(LEVEL_SIZE_X, LEVEL_SIZE_Y) * TILE_SIZE
	$"Border/Bottom".position.y = (LEVEL_SIZE_Y * TILE_SIZE) - (TILE_SIZE/2)
	$"Border/Right".position.x = (LEVEL_SIZE_X * TILE_SIZE) - (TILE_SIZE/2)
	$"Control/FloorSize".rect_size = Vector2(LEVEL_SIZE_X, LEVEL_SIZE_Y) * TILE_SIZE
	# Yes this is confusing, the texturerects are rotated:
	$"Control/FloorShadow2".rect_size.y = LEVEL_SIZE_X * TILE_SIZE
	$"Control/FloorShadow3".rect_size.y = LEVEL_SIZE_X * TILE_SIZE
	Global.set_deconstruct_mode(true)

func world_to_tile_coords(pos : Vector2):
	var retval : Vector2 = pos
	retval = retval / TILE_SIZE
	retval = retval.round()
	return retval

func tile_to_world_coords(tc : Vector2):
	var retval = tc * TILE_SIZE
	return retval

func get_tile(tc : Vector2):
	var key = tc.round() #Probably unnecessary, wish we had Vec2i
	return MapDict.get(key)

func set_tile(tc : Vector2, object : Node2D):
	var key = tc.round() #Probably unnecessary, wish we had Vec2i
	object.set_position(tile_to_world_coords(key))
	# The child is responsible for registering itself
	self.add_child(object)

func reg_tile(object : Node2D):
	var key = world_to_tile_coords(object.position)
	MapDict[key] = object
	object.set_position(tile_to_world_coords(key)) #snap

func rm_tile(tc : Vector2):
	var key = tc.round() #Probably unnecessary, wish we had Vec2i
	MapDict.erase(key)
