extends KinematicBody2D

enum State {STOPPED, WORKING, MOVING}
enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}

export var MAX_SPEED : float = 120.0
export var ACCEL_TIME : float = 1.5
export(TransitionType) var ACCEL_TRANS = Tween.TRANS_ELASTIC
export(EaseType) var ACCEL_EASE = Tween.EASE_IN_OUT

var cur_state = State.STOPPED
var cur_direction = Vector2(0, 0)
var cur_speed : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SnapToGrid()

func GetTileCoords():
	return get_parent().WorldToTileCoords(get_position())

func SnapToGrid():
	set_position(get_parent().TileToWorldCoords(GetTileCoords()))

func _speed_up():
	var tween = get_node("SpeedTween")
	tween.interpolate_property(self, "cur_speed", cur_speed, MAX_SPEED, ACCEL_TIME, ACCEL_TRANS, ACCEL_EASE)
	tween.start()

func _handle_stopped(delta):
	var curTile = get_parent().GetTile(GetTileCoords())
	if !is_instance_valid(curTile):
		return
	if curTile.has_method("GetPushVec"):
		cur_direction = curTile.GetPushVec()
		if cur_direction != Vector2.ZERO:
			cur_state = State.MOVING
			_speed_up()

func _physics_process(delta):
	match cur_state:
		State.STOPPED:
			_handle_stopped(delta)
		State.WORKING:
			pass
		State.MOVING:
			self.move_and_collide(cur_direction * cur_speed * delta)
