tool
extends BaseTile

# Called when the node enters the scene tree for the first time.
func _ready():
	item_id = Global.ItemType.WALLS

func IsStopper(_itemtype):
	return true
