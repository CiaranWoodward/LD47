extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("deconstruct_mode_changed", self, "_deconstruct_mode_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _deconstruct_mode_changed(enabled):
	if enabled != pressed:
		pressed = enabled

func _on_Deconstruct_toggled(button_pressed):
	Global.set_deconstruct_mode(button_pressed)
