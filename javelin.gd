extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lifetime = 10
var gravity = 120

var velocity = Vector2(0, 0)

func get_damage():
	return 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		get_parent().remove_child(self)
		
	rotation = atan2(velocity.y, velocity.x)
		
func _physics_process(delta):
	velocity.y += gravity * delta
	var c = move_and_collide(velocity * delta)
	if c != null:
		if c.collider == physics_map:
			get_parent().remove_child(self)
