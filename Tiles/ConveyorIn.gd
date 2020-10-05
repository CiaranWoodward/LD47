tool
extends BaseTile

export(Global.ItemType) var item_type = Global.ItemType.NONE
export var item_period = 5.0

onready var itemtimer = $ItemTimer

onready var icon = Global.instance_item(item_type)
var cur_itemvis
var has_item = false

# Called when the node enters the scene tree for the first time.
func _ready():
	itemtimer.start(item_period)
	$IconPoint.add_child(icon)
	if !Engine.editor_hint:
		$AnimationPlayer.play("Belt")

func _GenItem():
	if item_type == Global.ItemType.NONE:
		return
	if HasItem():
		return false
	cur_itemvis = Global.instance_item(item_type)
	has_item = true
	if is_instance_valid(cur_itemvis):
		$ItemPoint.add_child(cur_itemvis)
	$AnimationPlayer.play("In")
	return true

func HasItem():
	return (has_item)

func TakeItem():
	if(!HasItem()):
		return Global.ItemType.NONE
	var retval = item_type
	has_item = false
	if is_instance_valid(cur_itemvis):
		cur_itemvis.queue_free()
		cur_itemvis = null
	if retval != Global.ItemType.NONE:
		itemtimer.start(item_period)
	return retval

func IsStopper(_itemtype):
	return true

func _on_ItemTimer_timeout():
	_GenItem()
