extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var viewport = $Viewport

func update_viewport():
	var s = get_viewport().size
	viewport.size = (s / 3.0).ceil()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_viewport()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_viewport()
