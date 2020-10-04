tool
extends Node2D

export(Array, Color) var TILE_COLOR = [Color("b5b5b5"), Color("959595"), Color("c2c2c2")]

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count("default")
	modulate = TILE_COLOR[randi() % TILE_COLOR.size()]
