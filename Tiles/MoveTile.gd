tool
extends BaseTile

export(Global.Dir) var direction = Global.Dir.UP setget SetDirection

onready var animplayer = get_node("AnimationPlayer")
onready var animtree = get_node("AnimationTree")
onready var animsm : AnimationNodeStateMachinePlayback = animtree["parameters/playback"]

# Called when the node enters the scene tree for the first time.
func _ready():
	item_id = Global.ItemType.ARROW_PLATE
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
	if animsm.get_current_node() == "On":
		animsm.travel("On 2")
	else:
		animsm.travel("On")
