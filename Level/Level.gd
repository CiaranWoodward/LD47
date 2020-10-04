tool
extends YSort

# Tile size in pixels
const TILE_SIZE = 75

onready var moveTile = preload("res://Tiles/MoveTile.tscn")
onready var wallTile = preload("res://Tiles/WallTile.tscn")
onready var dumpTile = preload("res://Tiles/DumpTile.tscn")

var MapDict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
