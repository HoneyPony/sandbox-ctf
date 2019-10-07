extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var health = 3

var timer = 0

var hearts2
var hearts3

var player
var melee
var Block = preload("res://block.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	health *= 3
	hearts2 = get_node("hearts2")
	hearts3 = get_node("hearts3")
	player = get_node("/root/root/player")
	melee = player.get_node("item_swing/hit stuff")
	pass # Replace with function body.
	
func number(local_health):
	var highest = floor(local_health / 3)
	return highest * 4 + (local_health % 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var health1 = health
	var health2 = 0
	var health3 = 0
	
	if health1 > 60:
		health3 = health1 - 60
		health1 = 60
		
	if health1 > 30:
		health2 = health1 - 30
		health1 = 30
		
	if hearts3 != null:
		hearts3.region_rect.size.x = number(health3)
	if hearts2 != null:
		hearts2.region_rect.size.x = number(health2)
	region_rect.size.x = number(health1)
	
	if timer > 0:
		timer -= delta
	
	pass


func hit(body):
	if timer > 0:
		return
		
	var damage = 0
	
	if body == melee:
		damage = Block.damage(player.inventory.active_item().id)
	else:
		damage = body.get_damage()
	
	health -= damage
	if health < 1:
		get_parent().you_died()
		# for now
		get_node("/root/root/physics_map").remove_entity(get_parent())
		get_parent().get_parent().remove_child(get_parent())
	timer = 0.2
	
	get_parent().you_were_hit()
	
	$hit.play()
	pass # Replace with function body.
