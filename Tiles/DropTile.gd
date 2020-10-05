tool
extends BaseTile

signal item_taken
signal zone_cleared

onready var animtree = get_node("AnimationTree")
onready var animsm : AnimationNodeStateMachinePlayback = animtree["parameters/playback"]

var direction = Global.Dir.UP
var cur_item = Global.ItemType.NONE
var cur_itemvis

var trespass_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_setCollision()
	animtree.active = true
	animsm.start("Off")

func _setCollision():
	if HasItem():
		self.collision_layer = 0
		self.collision_mask = Global.PhyLayer.ROBO + Global.PhyLayer.EMPTY_ROBO
	else:
		self.collision_layer = 0
		self.collision_mask = 0

func _GiveItem(item : int):
	if item == Global.ItemType.NONE:
		return false
	if HasItem():
		return false
	cur_item = item
	_setCollision()
	cur_itemvis = Global.instance_item(cur_item)
	if is_instance_valid(cur_itemvis):
		self.add_child(cur_itemvis)
	animsm.travel("On")
	return true

func GetPushVec():
	return Global.get_dir_vec(direction)

func HasItem():
	return (cur_item != Global.ItemType.NONE)

func Use():
	animsm.travel("PulseOn")

func TakeItem():
	var retval = cur_item
	cur_item = Global.ItemType.NONE
	if is_instance_valid(cur_itemvis):
		cur_itemvis.queue_free()
		cur_itemvis = null
	_setCollision()
	if retval != Global.ItemType.NONE:
		emit_signal("item_taken")
		animsm.travel("Off")
	return retval

func IsStopper(_itemtype):
	return HasItem()

func IsClear():
	return trespass_count == 0

func _on_DropArea_body_entered(body):
	trespass_count += 1

func _on_DropArea_body_exited(body):
	trespass_count -= 1
	assert(trespass_count >= 0)
	if trespass_count == 0:
		emit_signal("zone_cleared")
