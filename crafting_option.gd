extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active = preload("res://sprite/crafting_option.png")
var inactive = preload("res://sprite/crafting_option_inactive.png")

var player

var in1
var in2
var in3
var count1
var count2
var count3

var min_position
var max_position

var Block = preload("res://block.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	
	$icon.texture = Block.get_icon(recipe.output)
	$output_count.text = String(recipe.output_count)
	$output_count.visible = recipe.output_count > 1
	
	in1 = get_node("../../crafting_in_1")
	in2 = get_node("../../crafting_in_2")
	in3 = get_node("../../crafting_in_3")
	
	count1 = get_node("../../crafting_count_1")
	count2 = get_node("../../crafting_count_2")
	count3 = get_node("../../crafting_count_3")
	
var used_mouse = false
var recipe

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(rect_position.x - 70) < 8:
		# am active
		texture = active
		in1.texture = Block.get_icon(recipe.input1)
		in2.texture = Block.get_icon(recipe.input2)
		in3.texture = Block.get_icon(recipe.input3)
		count1.text = String(recipe.input1_count)
		count1.visible = recipe.input1_count > 1
		count2.text = String(recipe.input2_count)
		count2.visible = recipe.input2_count > 1
		count3.text = String(recipe.input3_count)
		count3.visible = recipe.input3_count > 1
	else:
		texture = inactive
		return
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if mouse and !used_mouse:
			var result = player.inventory.make_recipe(recipe)
			if !result:
				get_parent().create_recipe_ui()
			used_mouse = true
	else:
		used_mouse = false

var mouse = false

func mouse_entered():
	mouse = true

func mouse_exited():
	mouse = false
