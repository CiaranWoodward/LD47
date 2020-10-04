tool
extends BaseTile

signal item_taken

var cur_item = Global.ItemType.NONE
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	_setCollision()

func _setCollision():
	if HasItem():
		self.collision_layer = Global.PhyLayer.ROBO + Global.PhyLayer.EMPTY_ROBO
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
	return true

func HasItem():
	return (cur_item != Global.ItemType.NONE)

func TakeItem():
	var retval = cur_item
	cur_item = Global.ItemType.NONE
	if is_instance_valid(cur_itemvis):
		cur_itemvis.queue_free()
		cur_itemvis = null
	_setCollision()
	if retval != Global.ItemType.NONE:
		emit_signal("item_taken")
	return retval

func IsStopper():
	return HasItem()
