extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var waiting = true

var possible_recipes = 0

var CraftingOption = preload("res://crafting_option.tscn")
var tooltip

# Called when the node enters the scene tree for the first time.
func _ready():
	tooltip = get_node("../../crafting_tooltip")
	player = global.player
	
func create_recipe_ui():
	get_node("../crafting_in_1").texture = null
	get_node("../crafting_in_2").texture = null
	get_node("../crafting_in_3").texture = null
	get_node("../crafting_count_1").visible = false
	get_node("../crafting_count_2").visible = false
	get_node("../crafting_count_3").visible = false
	
	tooltip.deactivate_all()
	
	for c in get_children():
		remove_child(c)
	
	var x = 70
	var total = 0
	
	possible_recipes = 0
	
	for recipe in player.inventory.recipes:
		if player.inventory.check_recipe(recipe):
			possible_recipes += 1
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
		
func check_again():
	var total = 0
	for recipe in player.inventory.recipes:
		if player.inventory.check_recipe(recipe):
			total += 1
			
	if total > possible_recipes:
		var delta = total - possible_recipes
		var x = get_children()[get_children().size() - 1].rect_position.x + 19
		for c in get_children():
			c.min_position -= delta * 19
		for recipe in player.inventory.recipes:
			var exists = false
			for c in get_children():
				if c.recipe == recipe:
					exists = true
					break
			if not exists:
				possible_recipes += 1
				var option = CraftingOption.instance()
				option.recipe = recipe
				option.rect_position.x = x
				option.max_position = x
				option.min_position = option.max_position - total * 19
				add_child(option)
				x += 19

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.inventory_open:
		if waiting:
			waiting = false
			create_recipe_ui()
		#check_again()
	else:
		waiting = true
