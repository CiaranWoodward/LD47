extends Node2D

onready var sprite = get_node("Sprite")

var dir_vec= Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetDirection(dir : int):
	dir = dir % 4
	match dir:
		Global.Dir.UP:
			dir_vec = Vector2(0, -1)
			sprite.set_rotation(0)
		Global.Dir.RIGHT:
			dir_vec = Vector2(1, 0)
			sprite.set_rotation(PI * 0.5)
		Global.Dir.DOWN:
			dir_vec = Vector2(0, 1)
			sprite.set_rotation(PI)
		Global.Dir.LEFT:
			dir_vec = Vector2(-1, 0)
			sprite.set_rotation(PI * 1.5)

func GetPushVec():
	return dir_vec
