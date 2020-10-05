tool
extends CenterContainer

export(Global.ItemType) var item_type = Global.ItemType.BAR setget _setitemtype
export(float) var size = 75 setget _setitemsize

onready var tr = get_node("TextureRect")

# Called when the node enters the scene tree for the first time.
func _ready():
	_setitemtype(item_type)
	_setitemsize(size)

func _setitemtype(newitem):
	item_type = newitem
	if is_instance_valid(tr):
		tr.texture = Global.get_icon_texture(newitem)

func _setitemsize(itemsize):
	size = itemsize
	if is_instance_valid(tr):
		tr.rect_min_size = Vector2(itemsize, itemsize)
