extends Node2D

# Tile size in pixels
const TILE_SIZE = 75

var MapDict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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

func GetTile(x : int, y : int):
	var key = [x, y]
	return MapDict[key]

func SetTile(x : int, y : int, object):
	var key = [x, y]
	MapDict[key] = object
