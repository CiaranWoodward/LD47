tool
extends BaseTile

signal item_taken

var cur_item = Global.ItemType.NONE
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	_setCollision(HasItem())

func _setCollision(enabled : bool):
	if enabled:
		self.collision_layer = 1
		self.collision_mask = 1
	else:
		self.collision_layer = 0
		self.collision_mask = 0

func HasItem():
	return (cur_item != Global.ItemType.NONE)

func TakeItem():
	var retval = cur_item
	cur_item = Global.ItemType.NONE
	if is_instance_valid(cur_itemvis):
		cur_itemvis.queue_free()
		cur_itemvis = null
	if retval != Global.ItemType.NONE:
		emit_signal("item_taken")
	return retval

func IsStopper():
	return HasItem()
