extends Camera2D

export var MAX_SPEED = 150.0
export var ACCEL_TIME = 0.5
export var STOP_TIME = 0.2
export(Global.TransitionType) var ACCEL_TRANS = Global.TransitionType.SINE
export var ZOOM_AMOUNT = 0.2
export var ZOOM_TIME = 0.2
export var ZOOM_MIN = 0.4
export var ZOOM_MAX = 4
export(Global.TransitionType) var ZOOM_TRANS = Global.TransitionType.SINE

onready var tween = get_node("Tween")

var speed = 0
var target_zoom = Vector2(1, 1)
var dir_vec = Vector2.ZERO
var moving = false
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and (event.button_index == BUTTON_RIGHT || event.button_index == BUTTON_MIDDLE):
		if event.is_pressed():
			dragging = true
			tween.remove(self, "dir_vec")
			tween.remove(self, "speed")
			speed = 0
			moving = false
			dir_vec = Vector2.ZERO
		else:
			dragging = false
	
	if dragging && event is InputEventMouseMotion:
		position -= event.relative * zoom.x

func _physics_process(delta):
	var rezoom = false
	if Input.is_action_just_released("zoom_in"):
		target_zoom -= Vector2(ZOOM_AMOUNT, ZOOM_AMOUNT)
		rezoom = true
	if Input.is_action_just_released("zoom_out"):
		target_zoom += Vector2(ZOOM_AMOUNT, ZOOM_AMOUNT)
		rezoom = true
	if target_zoom.x > ZOOM_MAX:
		target_zoom = Vector2(ZOOM_MAX, ZOOM_MAX)
	if target_zoom.x < ZOOM_MIN:
		target_zoom = Vector2(ZOOM_MIN, ZOOM_MIN)
	if rezoom && target_zoom != zoom:
		tween.remove(self, "zoom")
		tween.interpolate_property(self, "zoom", zoom, target_zoom, ZOOM_TIME, ZOOM_TRANS, Tween.EASE_IN_OUT)
		tween.start()
	
	if dragging:
		return
	
	var dir_delta = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		dir_delta.x += 1
	if Input.is_action_pressed("ui_left"):
		dir_delta.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir_delta.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir_delta.y += 1
	if speed == 0:
		dir_vec = dir_delta
	if dir_delta != Vector2.ZERO:
		dir_delta = dir_delta.normalized()
		tween.remove(self, "dir_vec")
		tween.interpolate_property(self, "dir_vec", dir_vec, dir_delta, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()
	
	if dir_delta != Vector2.ZERO && !moving:
		# just started moving
		tween.remove(self, "speed")
		tween.interpolate_property(self, "speed", speed, MAX_SPEED, ACCEL_TIME, ACCEL_TRANS, Tween.EASE_OUT)
		tween.start()
		moving = true
	
	if dir_delta == Vector2.ZERO && moving:
		# just stopped moving
		tween.remove(self, "speed")
		tween.interpolate_property(self, "speed", speed, 0, STOP_TIME, ACCEL_TRANS, Tween.EASE_OUT)
		tween.start()
		moving = false
	
	position += dir_vec * speed * delta * zoom.x
