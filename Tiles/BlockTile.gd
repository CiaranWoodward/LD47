tool
extends BaseTile

export(Global.ItemType) var item_type = Global.ItemType.NONE

var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_itemvis = Global.instance_item(item_type)
	if is_instance_valid(cur_itemvis):
		$"Sprite/ItemPoint".add_child(cur_itemvis)

func _setCollision():
		self.collision_layer = Global.PhyLayer.FULL_ROBO
		self.collision_mask = Global.PhyLayer.FULL_ROBO

func IsStopper(itemtype):
	return (itemtype == item_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
