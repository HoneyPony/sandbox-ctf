extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var waiting = true

var CraftingOption = preload("res://crafting_option.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	
func create_recipe_ui():
	for c in get_children():
		remove_child(c)
	
	var x = 70
	var total = 0
	
	for recipe in player.inventory.recipes:
		if player.inventory.check_recipe(recipe):
			var option = CraftingOption.instance()
			option.recipe = recipe
			option.rect_position.x = x
			option.max_position = x
			add_child(option)
			x += 19
			total += 19
			
	# We will overshoot by one
	total -= 19
			
	for c in get_children():
		c.min_position = c.max_position - total

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.inventory_open:
		if waiting:
			waiting = false
			create_recipe_ui()
	else:
		waiting = true