extends Node2D

# Tile size in pixels
const TILE_SIZE = 75

onready var moveTile = preload("res://Tiles/MoveTile.tscn")
onready var wallTile = preload("res://Tiles/WallTile.tscn")

var MapDict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#test code
	SetTile(Vector2(5,5), moveTile.instance())
	GetTile(Vector2(5,5)).SetDirection(Global.Dir.RIGHT)
	SetTile(Vector2(6,5), moveTile.instance())
	SetTile(Vector2(7,5), moveTile.instance())
	SetTile(Vector2(7,3), moveTile.instance())
	GetTile(Vector2(7,3)).SetDirection(Global.Dir.LEFT)
	SetTile(Vector2(5,3), moveTile.instance())
	GetTile(Vector2(5,3)).SetDirection(Global.Dir.DOWN)
	SetTile(Vector2(5,6), wallTile.instance())
	SetTile(Vector2(8,5), wallTile.instance())
	SetTile(Vector2(7,2), wallTile.instance())
	SetTile(Vector2(4,3), wallTile.instance())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func WorldToTileCoords(pos : Vector2):
	var retval : Vector2 = pos# + Vector2(TILE_SIZE/2 * sign(pos.x), TILE_SIZE/2 * sign(pos.y))
	retval = retval / TILE_SIZE
	retval = retval.round()
	return retval

func TileToWorldCoords(tc : Vector2):
	var retval = tc * TILE_SIZE
	return retval

func GetTile(tc : Vector2):
	var key = tc.round() #Probably unnecessary, wish we had Vec2i
	return MapDict.get(key)

func SetTile(tc : Vector2, object : Node2D):
	var key = tc.round() #Probably unnecessary, wish we had Vec2i
	MapDict[key] = object
	self.add_child(object)
	object.set_position(TileToWorldCoords(key))
