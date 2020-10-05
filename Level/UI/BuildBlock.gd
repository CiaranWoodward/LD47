tool
extends PanelContainer

const icon = preload("res://Graphics/UI/Icon.tscn")

onready var icon_container = get_node("MarginContainer/VBoxContainer/IconContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	if !is_instance_valid(icon_container):
		return
	for item in Global.ItemType.values():
		if item == Global.ItemType.NONE:
			continue
		var newicon = icon.instance()
		newicon.item_type = item
		newicon.size = 50
		icon_container.add_child(newicon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
