tool
extends Node

enum ItemType {NONE,BAR,COG,PLATE}
enum Dir {UP, RIGHT, DOWN, LEFT}
enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}
enum PhyLayer {ROBO = 1, FULL_ROBO = 2, EMPTY_ROBO = 4}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func instance_item(itemnum : int):
	match itemnum:
		ItemType.BAR:
			return preload("res://Items/IronBar.tscn").instance()
		ItemType.COG:
			return preload("res://Items/Cog.tscn").instance()
		ItemType.PLATE:
			return preload("res://Items/IronPlate.tscn").instance()

func get_dir_vec(dir : int):
	var dir_vec = Vector2.ZERO
	dir = dir % 4
	match dir:
		Global.Dir.UP:
			dir_vec = Vector2(0, -1)
		Global.Dir.RIGHT:
			dir_vec = Vector2(1, 0)
		Global.Dir.DOWN:
			dir_vec = Vector2(0, 1)
		Global.Dir.LEFT:
			dir_vec = Vector2(-1, 0)
	return dir_vec
