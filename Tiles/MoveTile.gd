tool
extends BaseTile

export(Global.Dir) var direction = Global.Dir.UP setget SetDirection

onready var animplayer = get_node("AnimationPlayer")
onready var animtree = get_node("AnimationTree")
onready var animsm : AnimationNodeStateMachinePlayback = animtree["parameters/playback"]

# Called when the node enters the scene tree for the first time.
func _ready():
	animtree.active = true
	animsm.start("Off")

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

func Use():
	animsm.travel("On")
	if animplayer.current_animation == "On":
		animplayer.stop()
		animplayer.play("On")
