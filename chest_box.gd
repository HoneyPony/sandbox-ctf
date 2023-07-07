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

var tooltip

# Called when the node enters the scene tree for the first time.
func _ready():
	player = global.player
	slot = int(get_name())
	float_ui = get_node("../../../../floating_item")
	tooltip = get_node("../../../../tooltip")
	pass # Replace with function body.
	
func get_item():
	return player.current_chest.items[slot]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = global.player
	if player.current_chest == null:
		#print("no chest")
		has_mouse = false
		return
	
	if !player.inventory_open or !player.chest_open:
		has_mouse = false
		return
	
	$frame/icon.visible = get_item().id != -1
	$frame/count.visible = get_item().count > 1
	$frame/count.text = String(get_item().count)
	$frame/icon.texture = Block.get_icon(get_item().id)
	
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
	if player.current_chest == null:
		return
	player.inventory.float_slot(slot, true)
	
func right_clicked():
	if player.current_chest == null:
		return
	if player.inventory.split_slot(slot, true):
		used_right_mouse = true
	else:
		right_mouse_delay = 0.1
			

func mouse_enter():
	has_mouse = true
	tooltip.activate(slot, true)

func mouse_exit():
	has_mouse = false
	tooltip.deactivate(slot, true)
