tool
extends BaseTile

const DROP_TILE = preload("res://Tiles/DropTile.tscn")

export(Array, Global.ItemType) var required_items = []
export(Global.ItemType) var item_out
export var work_time = 2.0
export(Global.Dir) var direction = Global.Dir.UP

# index-matched with required_items (basically, is it present?)
var inventory = []
var isReady = true
var pendingRelease = false
var pendingPickup = false
var dropTile : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Sprite/ItemPoint".add_child(Global.instance_item(item_out))
	item_id = Global.ItemType.MACHINE
	if Engine.editor_hint:
		return
	var dirvec = Global.get_dir_vec(direction)
	var tc = get_parent().world_to_tile_coords(get_position())
	for item in required_items:
		inventory.push_back(false)
	dropTile = DROP_TILE.instance()
	dropTile.direction = direction
	get_parent().call_deferred("set_tile", tc + dirvec, dropTile)
	dropTile.connect("item_taken", self, "_item_taken")
	dropTile.connect("zone_cleared", self, "_zone_cleared")
	_set_building(false)
	_update_overlay()

func _exit_tree():
	if Engine.editor_hint:
		return
	dropTile.queue_free()

func _update_overlay():
	if !isReady:
		$Overlay.visible = false
		return
	$Overlay.visible = true
	var items_req = []
	for i in range(required_items.size()):
		if !inventory[i]:
			items_req.push_back(required_items[i])
	if items_req.size() == 0:
		$Overlay.visible = false
		return
	$Overlay.visible = true
	$"Overlay/MachineOverlay".SetOverlay(items_req)

func _checkComplete():
	var complete = true
	
	if pendingPickup:
		return
	for check in inventory:
		if !check:
			complete = false
			break
	
	if complete:
		for i in range(inventory.size()):
			inventory[i] = false
		isReady = false
		get_node("WorkingTimer").start(work_time);
		_set_building(true)
		_update_overlay()

func _item_taken():
	pendingPickup = false
	_checkComplete()

func _release_item():
	pendingRelease = false
	isReady = true
	if item_out == Global.ItemType.ROBO:
		var newRobo = preload("res://Robo/Robo.tscn").instance()
		newRobo.position = dropTile.position
		get_parent().add_child(newRobo)
	else:
		pendingPickup = true
		dropTile._GiveItem(item_out)
	_update_overlay()

func _zone_cleared():
	if pendingRelease:
		_release_item()

func _set_building(isbuilding : bool):
	if isbuilding:
		$TopRight.play("Building")
		$TopLeft.play("Building")
		$"Sprite/Slots/FrontLeft/FrontLeft".play("Building")
		$"Sprite/Slots/FrontRight/FrontRight".play("Building")
	else:
		$TopRight.play("Idle")
		$TopLeft.play("Idle")
		$"Sprite/Slots/FrontLeft/FrontLeft".stop()
		$"Sprite/Slots/FrontRight/FrontRight".stop()

func IsStopper(_itemtype):
	return true

func GiveItem(item : int):
	var retval = false
	if item == Global.ItemType.NONE:
		return false
	if !isReady:
		return false
	
	for i in range(required_items.size()):
		if !inventory[i] && required_items[i] == item:
			inventory[i] = true
			retval = true
			break
	
	_checkComplete()
	_update_overlay()
	return retval

func _on_WorkingTimer_timeout():
	_set_building(false)
	if dropTile.IsClear():
		_release_item()
	else:
		pendingRelease = true
