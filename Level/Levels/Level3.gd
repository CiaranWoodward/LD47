extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.clear_items()
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.deposit_item(Global.ItemType.ARROW_PLATE)
	Global.connect("itemcounts_changed", self, "check_completion")

func check_completion():
	if Global.get_itemcount(Global.ItemType.ARROW_PLATE) >= 5:
		get_node("Level/HUD/NextLevel").visible = true

func next_level():
	get_tree().change_scene("res://Level/Levels/Level4.tscn")
