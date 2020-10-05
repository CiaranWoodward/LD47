tool
extends BaseTile

export var REMOVE_TIME = 0.4

var cur_itemvis : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.editor_hint:
		$AnimationPlayer.play("Belt")

func _hasItem():
	return (is_instance_valid(cur_itemvis))

func _send_item(item, itemnum):
	cur_itemvis = item
	Global.deposit_item(itemnum)
	$"Sprite/ItemPoint".add_child(cur_itemvis)
	$Fader.remove_all()
	$Fader.interpolate_property(cur_itemvis, "modulate", cur_itemvis.modulate, Color(1, 1, 1, 0), REMOVE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	$Fader.start()
	$AnimationPlayer.play("Out")

func GiveItem(item : int):
	if item == Global.ItemType.NONE:
		return false
	if _hasItem():
		return false
	_send_item(Global.instance_item(item), item)
	return true

func GiveSelf(dirvec : Vector2, robo : KinematicBody2D):
	if dirvec != Vector2(0, -1):
		return false
	robo.get_parent().remove_child(robo)
	robo.collision_layer = 0
	robo.collision_mask = 0
	robo.position = Vector2.ZERO
	_send_item(robo, Global.ItemType.ROBO)
	return true

func IsStopper(_itemtype):
	return true

func _on_Fader_tween_completed(object, key):
	if key == ":modulate":
		cur_itemvis.queue_free()
