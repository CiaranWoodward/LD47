extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_NextLevel_pressed():
	if is_instance_valid(Global.current_level) && Global.current_level.has_method("next_level"):
		Global.current_level.next_level()
