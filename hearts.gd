extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var health = 3

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	health *= 3
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var highest = floor(health / 3)
	region_rect.size.x = highest * 4 + (health % 3)
	
	if timer > 0:
		timer -= delta
	
	pass


func hit(body):
	if timer > 0:
		return
	
	health -= 1
	if health < 1:
		get_parent().you_died()
		# for now
		get_node("/root/root/physics_map").remove_entity(get_parent())
		get_parent().get_parent().remove_child(get_parent())
	timer = 0.2
	
	get_parent().you_were_hit()
	
	$hit.play()
	pass # Replace with function body.
