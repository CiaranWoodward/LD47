tool
extends Node

enum ItemType {NONE,BAR,COG,PLATE,COPPER_PLATE,ARROW_PLATE,CIRCUITBOARD,BLOCK_TILE,COPPER_BAR,MACHINE,ROBO_HEAD,ROBO_PART,WALLS,WIRES,ROBO}
enum Dir {UP, RIGHT, DOWN, LEFT}
enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}
enum PhyLayer {ROBO = 1, FULL_ROBO = 2, EMPTY_ROBO = 4, SPECIAL_TILE = 8}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func instance_item(itemnum : int):
	match itemnum:
		ItemType.BAR:
			return preload("res://Items/IronBar.tscn").instance()
		ItemType.COG:
			return preload("res://Items/Cog.tscn").instance()
		ItemType.PLATE:
			return preload("res://Items/IronPlate.tscn").instance()
		ItemType.COPPER_PLATE:
			return preload("res://Items/CopperPlate.tscn").instance()
		ItemType.ARROW_PLATE:
			return preload("res://Items/ArrowTile.tscn").instance()
		ItemType.CIRCUITBOARD:
			return preload("res://Items/Circuitboard.tscn").instance()
		ItemType.BLOCK_TILE:
			return preload("res://Items/DumpTile.tscn").instance()
		ItemType.COPPER_BAR:
			return preload("res://Items/CopperBar.tscn").instance()
		ItemType.MACHINE:
			return preload("res://Items/Machine.tscn").instance()
		ItemType.ROBO_HEAD:
			return preload("res://Items/RoboHead.tscn").instance()
		ItemType.ROBO_PART:
			return preload("res://Items/RoboPart.tscn").instance()
		ItemType.WIRES:
			return preload("res://Items/Wires.tscn").instance()
		ItemType.WALLS:
			return preload("res://Items/Wall.tscn").instance()
		ItemType.ROBO:
			return preload("res://Items/RoboHead.tscn").instance()

func get_icon_texture(itemnum : int):
	match itemnum:
		ItemType.BAR:
			return preload("res://Items/Icons/IronBar0000.png")
		ItemType.COG:
			return preload("res://Items/Icons/Cog0000.png")
		ItemType.PLATE:
			return preload("res://Items/Icons/IronPlate0000.png")
		ItemType.COPPER_PLATE:
			return preload("res://Items/Icons/CopperPlate0000.png")
		ItemType.ARROW_PLATE:
			return preload("res://Items/Icons/ArrowTile0000.png")
		ItemType.CIRCUITBOARD:
			return preload("res://Items/Icons/Curicuitboard0000.png")
		ItemType.BLOCK_TILE:
			return preload("res://Items/Icons/DumpTile0000.png")
		ItemType.COPPER_BAR:
			return preload("res://Items/Icons/CopperBar0000.png")
		ItemType.MACHINE:
			return preload("res://Items/Icons/Machine0000.png")
		ItemType.ROBO_HEAD:
			return preload("res://Items/Icons/RoboHead0000.png")
		ItemType.ROBO_PART:
			return preload("res://Items/Icons/RoboPart0000.png")
		ItemType.WIRES:
			return preload("res://Items/Icons/Wires0000.png")
		ItemType.WALLS:
			return preload("res://Items/Icons/Wall0000.png")
		ItemType.ROBO:
			return preload("res://Items/Icons/Robo0000.png")

func get_dir_vec(dir : int):
	var dir_vec = Vector2.ZERO
	dir = dir % 4
	match dir:
		Global.Dir.UP:
			dir_vec = Vector2(0, -1)
		Global.Dir.RIGHT:
			dir_vec = Vector2(1, 0)
		Global.Dir.DOWN:
			dir_vec = Vector2(0, 1)
		Global.Dir.LEFT:
			dir_vec = Vector2(-1, 0)
	return dir_vec

func deposit_item(itemnum : int):
	pass
