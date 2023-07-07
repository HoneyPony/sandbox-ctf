extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var has_mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var b = 1.0
	if has_mouse:
		b = 0.0
	modulate.b = b
	
	if has_mouse and Input.is_mouse_button_pressed(BUTTON_LEFT):
		var name = get_name()
		if name == "play_normal":
			global.permadeath = false
			get_tree().change_scene("res://main.tscn")
		if name == "play_perma":
			global.permadeath = true
			get_tree().change_scene("res://main.tscn")
		if name == "ok":
			get_tree().change_scene("res://menu.tscn")
		

func mouse_enter():
	has_mouse = true
	
func mouse_exit():
	has_mouse = false
