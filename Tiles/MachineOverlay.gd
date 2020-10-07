extends CenterContainer

var overlayTile = preload("res://Tiles/MachineOverlayTile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetOverlay(ItemArray):
	for child in $Grid.get_children():
		child.queue_free()
	for item in ItemArray:
		var newtile = overlayTile.instance()
		newtile.get_node("Margin/Icon").item_type = item
		$Grid.add_child(newtile)
