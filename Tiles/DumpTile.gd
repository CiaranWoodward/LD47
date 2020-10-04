tool
extends BaseTile

var cur_item = Global.ItemType.NONE
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	_setCollision()

func _setCollision():
	if _hasItem():
		self.collision_layer = Global.PhyLayer.ROBO + Global.PhyLayer.EMPTY_ROBO
		self.collision_mask = Global.PhyLayer.ROBO + Global.PhyLayer.EMPTY_ROBO
	else:
		self.collision_layer = Global.PhyLayer.FULL_ROBO
		self.collision_mask = Global.PhyLayer.FULL_ROBO

func _hasItem():
	return (cur_item != Global.ItemType.NONE)

func GiveItem(item : int):
	if item == Global.ItemType.NONE:
		return false
	if _hasItem():
		return false
	cur_item = item
	_setCollision()
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
	_setCollision()
	return retval

func IsStopper():
	return _hasItem()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
