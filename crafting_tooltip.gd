extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active_node
var active = false

var player

var Block = preload("res://block.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player.inventory_open:
		visible = false
		return
	
	if active_node == null:
		visible = false
		return
		
	visible = active and player.inventory_open
	$title.text = Block.item_name(active_node.recipe.output)
	$label.text = Block.item_description(active_node.recipe.output)
	
	var target = get_global_mouse_position()
	var offset_x = 0
	var offset_y = 0
	
	if target.x > get_viewport().size.x / 2.0:
		offset_x -= rect_size.x
		
	if target.y > get_viewport().size.y / 2.0:
		offset_y -= rect_size.y
		
	if target.y + offset_y < 0:
		offset_y = -target.y
		
	rect_position = target + Vector2(offset_x, offset_y)

func activate(slot):
	active_node = slot
	active = true
	
func deactivate(slot):
	if slot == active_node:
		active = false
		
func deactivate_all():
	active_node = null
