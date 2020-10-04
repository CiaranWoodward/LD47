extends StaticBody2D

const DROP_TILE = preload("res://Tiles/DropTile.tscn")

export(Array, Global.ItemType) var required_items = []
export(Global.ItemType) var item_out
export var work_time = 2.0

# index-matched with required_items (basically, is it present?)
var inventory = []
var isReady = true
var direction = Global.Dir.UP
var dropTile

# Called when the node enters the scene tree for the first time.
func _ready():
	var dirvec = Global.get_dir_vec(direction)
	var tc = get_parent().world_to_tile_coords(get_position())
	for item in required_items:
		inventory.push_back(false)
	dropTile = DROP_TILE.instance()
	get_parent().set_tile(tc + dirvec, dropTile)

func _checkComplete():
	var complete = true
	
	for check in inventory:
		if !check:
			complete = false
			break
	
	if complete:
		for i in range(inventory.size()):
			inventory[i] = false
		isReady = false
		get_node("WorkingTimer").start(work_time);

func _item_taken():
	pass

func IsStopper():
	return true

func GiveItem(item : int):
	if item == Global.ItemType.NONE:
		return false
	if !isReady:
		return false
	
	for i in range(required_items.size()):
		if !inventory[i] && required_items[i] == item:
			inventory[i] = true
			return true
	
	return false

func _on_WorkingTimer_timeout():
	isReady = true
