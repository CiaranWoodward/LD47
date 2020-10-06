extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.time_scale = 1

func _on_FastForward_toggled(button_pressed):
	if button_pressed:
		Engine.time_scale = 3
	else:
		Engine.time_scale = 1
