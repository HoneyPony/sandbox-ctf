extends Node2D

export var shrink = 1

func setup_globals():
	global.root = self
	global.physics_map = get_node("physics_map")
	global.platform_map = get_node("platform_map")
	global.walls = get_node("walls")
	global.tiles = get_node("tiles")
	global.spawn_point = get_node("spawn_point")
	global.player = get_node("player")
	global.music = get_node("music")
	global.light_viewport = get_node("light_viewport")
	global.cursor = get_node("cursor")



# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(0, 0), shrink)
	setup_globals()
