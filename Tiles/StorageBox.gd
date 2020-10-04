tool
extends BaseTile

export(Global.ItemType) var item_type = Global.ItemType.NONE setget _set_item
export var max_size : int = 99

var itemslots = []

var item_count : int = 0
var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	itemslots.push_back($"Sprite/Box/Item1")
	itemslots.push_back($"Sprite/Box/Item2")
	itemslots.push_back($"Sprite/Box/Item3")
	_set_item(item_type)
	if !Engine.editor_hint:
		_set_itemvis()

func _set_item(new_item):
	item_type = new_item
	
	for itemslot in itemslots:
		for chi in itemslot.get_children():
			chi.queue_free()
	
	for itemslot in itemslots:
		itemslot.add_child(Global.instance_item(item_type))

func _hasItem():
	return (item_count > 0)

func _set_itemvis():
	for i in range(itemslots.size()):
		itemslots[i].visible = (i < item_count)

func GiveItem(item : int):
	if item == Global.ItemType.NONE:
		return false
	if item_count >= max_size:
		return false
	if item != item_type:
		return false
	item_count += 1
	_set_itemvis()
	return true

func TakeItem():
	var retval = Global.ItemType.NONE
	if item_count > 0:
		retval = item_type
		item_count -= 1
	_set_itemvis()
	return retval

func IsStopper(_itemtype):
	return true
