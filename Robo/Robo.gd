extends KinematicBody2D

enum State {STOPPED, WORKING, MOVING}

var cur_state = State.STOPPED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	match cur_state:
		State.STOPPED:
			pass
		State.WORKING:
			pass
		State.MOVING:
			pass
