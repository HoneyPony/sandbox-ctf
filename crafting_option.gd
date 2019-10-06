extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active = preload("res://sprite/crafting_option.png")
var inactive = preload("res://sprite/crafting_option_inactive.png")

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	recipe = player.inventory.recipes[0]
	
var used_mouse = false
var recipe

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(rect_position.x - 70) < 8:
		# am active
		texture = active
	else:
		texture = inactive
		return
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if mouse and !used_mouse:
			player.inventory.make_recipe(recipe)
			used_mouse = true
	else:
		used_mouse = false

var mouse = false

func mouse_entered():
	mouse = true

func mouse_exited():
	mouse = false
