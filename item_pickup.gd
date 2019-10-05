extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id_to_tex = {
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png")
}

var id = 0
var player

var accepted = false

var anim = 0

var last_position

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	last_position = position
	pass # Replace with function body.
	
func set_id(x):
	id = x
	$item.texture = id_to_tex.get(id)

func picked_up(unused):
	if accepted:
		return
	
	if player.inventory.accept(id):
		accepted = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt):
	if accepted:
		modulate.a = 1.0 - anim
		anim += dt
		if anim > 1:
			get_parent().remove_child(self)
	var delta = position - last_position
	if delta.length_squared() < 0.0001:
		position.x = round(position.x)
		position.y = round(position.y)
	last_position = position
