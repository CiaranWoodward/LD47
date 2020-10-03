extends Node

enum ItemType {NONE,BAR,COG,PLATE}
enum Dir {UP, RIGHT, DOWN, LEFT}
enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func instance_item(itemnum : int):
	match itemnum:
		ItemType.BAR:
			return preload("res://Items/BarItem.tscn").instance()
		ItemType.COG:
			return preload("res://Items/CogItem.tscn").instance()
		ItemType.PLATE:
			return preload("res://Items/Graphics/Plate.png").instance()
