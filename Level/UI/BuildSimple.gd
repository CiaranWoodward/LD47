extends PanelContainer

var _name = "None"
var _itemtype = Global.ItemType.NONE
var _instancetype

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("itemcounts_changed", self, "regen")

func setup(name, itemtype, instancetype):
	_name = name
	_itemtype = itemtype
	_instancetype = instancetype
	$"MarginContainer/VBoxContainer/HBoxContainer2/Name".text = name
	$"MarginContainer/VBoxContainer/HBoxContainer/Icon".item_type = itemtype
	regen()

func regen():
	var count = Global.get_itemcount(_itemtype)
	if count > 0:
		$"MarginContainer/VBoxContainer/HBoxContainer2/Count".text = "Count: %d" % Global.get_itemcount(_itemtype)
		visible = true
	else:
		visible = false

func _on_BuildSimple_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == BUTTON_LEFT:
			if is_instance_valid(Global.current_level) && Global.take_item(_itemtype):
				var ins = _instancetype.instance()
				ins.item_id = _itemtype
				Global.current_level.get_build_cursor().Set(ins)
