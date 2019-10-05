extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tilemap
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap = get_node("/root/root/tiles")
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var xs = round(player.position.x / 4)
	var ys = round(player.position.y / 4)
	
	for x in range(xs - 2, xs + 3):
		for y in range(ys - 2, ys + 3):
			if tilemap.get_cell(x, y) != -1:
				set_cell(x, y, 0)
