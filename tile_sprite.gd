extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func snap_number(num, count):
	var res = int(num) % count
	if res < 0: res += count
	return res

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = snap_number(position.x / 4, 4)
	var y = snap_number(position.y / 4, 4)
	set_region_rect(Rect2(x * 4, y * 4, 4, 4))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
