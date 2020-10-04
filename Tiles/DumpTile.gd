tool
extends BaseTile

var cur_item = Global.ItemType.NONE
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	# test code:
	GiveItem(Global.ItemType.BAR)
	
	_setCollision(_hasItem())

func _setCollision(enabled : bool):
	if enabled:
		self.collision_layer = 1
		self.collision_mask = 1
	else:
		self.collision_layer = 0
		self.collision_mask = 0

func _hasItem():
	return (cur_item != Global.ItemType.NONE)

func GiveItem(item : int):
	if item == Global.ItemType.NONE:
		return false
	if _hasItem():
		return false
	cur_item = item
	cur_itemvis = Global.instance_item(cur_item)
	if is_instance_valid(cur_itemvis):
		self.add_child(cur_itemvis)
	return true

func TakeItem():
	var retval = cur_item
	cur_item = Global.ItemType.NONE
	if is_instance_valid(cur_itemvis):
		cur_itemvis.queue_free()
		cur_itemvis = null
	return retval

func IsStopper():
	return _hasItem()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
