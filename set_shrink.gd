extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var shrink = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_IGNORE, Vector2(0, 0), shrink)

