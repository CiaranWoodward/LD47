extends Node2D

# Tile size in pixels
const TILE_SIZE = 75

onready var moveTile = preload("res://Tiles/MoveTile.tscn")
onready var wallTile = preload("res://Tiles/WallTile.tscn")
onready var dumpTile = preload("res://Tiles/DumpTile.tscn")

var MapDict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#test code
	set_tile(Vector2(5,5), moveTile.instance())
	get_tile(Vector2(5,5)).SetDirection(Global.Dir.RIGHT)
	set_tile(Vector2(6,5), moveTile.instance())
	set_tile(Vector2(7,5), moveTile.instance())
	set_tile(Vector2(7,3), moveTile.instance())
	get_tile(Vector2(7,3)).SetDirection(Global.Dir.LEFT)
	set_tile(Vector2(5,3), moveTile.instance())
	get_tile(Vector2(5,3)).SetDirection(Global.Dir.DOWN)
	set_tile(Vector2(5,6), wallTile.instance())
	set_tile(Vector2(8,5), wallTile.instance())
	set_tile(Vector2(7,2), wallTile.instance())
	set_tile(Vector2(4,3), dumpTile.instance())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	MapDict[key] = object
	object.set_position(tile_to_world_coords(key))
	self.add_child(object)

func rm_tile(tc : Vector2):
	var key = tc.round() #Probably unnecessary, wish we had Vec2i
	MapDict.erase(key)
