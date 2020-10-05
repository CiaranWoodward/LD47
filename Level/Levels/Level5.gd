extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.clear_items()
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.connect("itemcounts_changed", self, "check_completion")

func check_completion():
	if Global.get_itemcount(Global.ItemType.ROBO) >= 4:
		get_node("Level/HUD/NextLevel").visible = true

func next_level():
	get_tree().change_scene("res://Level/Levels/Level6.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
