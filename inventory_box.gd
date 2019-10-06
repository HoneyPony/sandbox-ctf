extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var slot
var player
var float_ui

var has_mouse = false
var used_mouse = false
var used_right_mouse = false
var right_mouse_delay = 0

var Block = preload("res://block.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/root/player")
	slot = int(get_name())
	float_ui = get_node("../../../../floating_item")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !player.inventory_open:
		return
	
	$frame/icon.visible = player.inventory.items[slot].id != -1
	$frame/count.visible = player.inventory.items[slot].count > 1
	$frame/count.text = String(player.inventory.items[slot].count)
	$frame/icon.texture = Block.get_icon(player.inventory.items[slot].id)
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if has_mouse and !used_mouse:
			clicked()
			used_mouse = true
	else:
		used_mouse = false
		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if has_mouse and !used_right_mouse and (right_mouse_delay <= 0):
			right_clicked()
	else:
		used_right_mouse = false
		
	if right_mouse_delay > 0:
		right_mouse_delay -= delta
	
func clicked():
	player.inventory.float_slot(slot)
	
func right_clicked():
	if player.inventory.split_slot(slot):
		used_right_mouse = true
	else:
		right_mouse_delay = 0.1
			

func mouse_enter():
	has_mouse = true

func mouse_exit():
	has_mouse = false
