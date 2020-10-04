tool
extends BaseTile

export(Global.Dir) var direction = Global.Dir.UP setget SetDirection

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetDirection(dir : int):
	dir = dir % 4
	direction = dir
	match dir:
		Global.Dir.UP:
			set_rotation(0)
		Global.Dir.RIGHT:
			set_rotation(PI * 0.5)
		Global.Dir.DOWN:
			set_rotation(PI)
		Global.Dir.LEFT:
			set_rotation(PI * 1.5)

func GetPushVec():
	return Global.get_dir_vec(direction)
