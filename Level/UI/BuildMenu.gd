extends VBoxContainer

const buildsimple = preload("res://Level/UI/BuildSimple.tscn")
const buildfactory = preload("res://Level/UI/BuildFactory.tscn")
const buildblock = preload("res://Level/UI/BuildBlock.gd")

var buildable = {
	Global.ItemType.ARROW_PLATE : preload("res://Tiles/MoveTile.tscn"),
	Global.ItemType.ROBO : preload("res://Robo/Robo.tscn"),
	Global.ItemType.STORAGE_BOX : preload("res://Tiles/StorageBox.tscn"),
	Global.ItemType.WALLS : preload("res://Tiles/WallTile.tscn"),
	Global.ItemType.BLOCK_TILE : preload("res://Tiles/BlockTile.tscn"),
	Global.ItemType.MACHINE : preload("res://Tiles/MachineTile.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var newtile = buildsimple.instance()
	newtile.setup("Arrow Tile", Global.ItemType.ARROW_PLATE, buildable[Global.ItemType.ARROW_PLATE])
	add_child(newtile)
	newtile = buildsimple.instance()
	newtile.setup("Wall Tile", Global.ItemType.WALLS, buildable[Global.ItemType.WALLS])
	add_child(newtile)
	newtile = buildsimple.instance()
	newtile.setup("Robot", Global.ItemType.ROBO, buildable[Global.ItemType.ROBO])
	add_child(newtile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
