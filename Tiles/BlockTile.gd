tool
extends BaseTile

export(Global.ItemType) var item_type = Global.ItemType.NONE

onready var animtree = get_node("AnimationTree")
onready var animsm : AnimationNodeStateMachinePlayback = animtree["parameters/playback"]

var cur_itemvis

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_itemvis = Global.instance_item(item_type)
	if is_instance_valid(cur_itemvis):
		$"Sprite/ItemPoint".add_child(cur_itemvis)
	animtree.active = true
	animsm.start("Off")
	item_id = Global.ItemType.BLOCK_TILE

func _setCollision():
		self.collision_layer = 0
		self.collision_mask = 0

func IsStopper(itemtype):
	return (itemtype == item_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BlockArea_body_entered(body):
	if body.has_method("Stop") && body.has_method("GetCurItem"):
		if body.GetCurItem() == item_type:
			body.Stop()
			animsm.travel("On")
