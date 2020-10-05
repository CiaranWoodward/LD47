tool
extends Control

enum Emotion {HAPPY, ANGRY, NORMAL}

export(Array, String, MULTILINE) var speech = [] setget _setspeech
export(Array, Emotion) var emotion = [] setget _setemotion

onready var textanim = get_node("NinePatchRect/Text/Animate")
onready var text = get_node("NinePatchRect/Text")

onready var happy = get_node("NinePatchRect/Artie/Happy")
onready var angry = get_node("NinePatchRect/Artie/Angry")
onready var normal = get_node("NinePatchRect/Artie/Normal")

var current_stage : int = 0
var active : bool = false

func _setspeech(newspeech : Array):
	speech = newspeech
	emotion.resize(speech.size())
	for i in range(emotion.size()):
		if emotion[i] == null:
			emotion[i] = Emotion.NORMAL

func _setemotion(newemotion):
	if newemotion.size() != emotion.size():
		return
	emotion = newemotion

func _set_curemote(emote):
	match emote:
		Emotion.HAPPY:
			happy.visible = true
			angry.visible = false
			normal.visible = false
		Emotion.ANGRY:
			happy.visible = false
			angry.visible = true
			normal.visible = false
		Emotion.NORMAL:
			happy.visible = false
			angry.visible = false
			normal.visible = true

func _set_text(i : int):
	if i >= speech.size():
		$Fade.play("FadeOut")
		active = false
	else:
		textanim.stop()
		text.visible_characters = 0
		text.text = speech[i]
		textanim.play("Speak")
		_set_curemote(emotion[i])
		active = true

func _advance_text():
	if !active:
		return
	if text.visible_characters < text.text.length():
		return
	current_stage += 1
	_set_text(current_stage)

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.editor_hint:
		$Fade.play("FadeIn")

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		_advance_text()

func _on_Fade_animation_finished(anim_name):
	if anim_name == "FadeIn":
		_set_text(0)

func _on_Dialogue_gui_input(event):
	if event is InputEventMouseButton and (event.button_index == BUTTON_LEFT):
		if event.is_pressed():
			_advance_text()
