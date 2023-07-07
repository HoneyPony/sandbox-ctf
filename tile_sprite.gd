extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var has_mouse = false

func snap_number(num, count):
	var res = int(num) % count
	if res < 0: res += count
	return res

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = snap_number(position.x / 4, 4)
	var y = snap_number(position.y / 4, 4)
	set_region_rect(Rect2(x * 4, y * 4, 4, 4))
	
func report():
	var p = get_local_mouse_position()
	
	if p.x > 0 and p.x < 4:
		if p.y > 0 and p.y < 4:
			return true
	return false
