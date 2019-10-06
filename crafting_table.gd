extends Area2D

# NOTE TO SELF:
# The collision layer bit for this thing can be used for other crafting stations
# if we really need them.

var player

func _ready():
	player = get_node("/root/root/player")

func player_enter(body):
	# If I were smart I would just modify the body crafting table # but oh well
	player.crafting_tables += 1
	player.notify_crafting()


func player_exit(body):
	player.crafting_tables -= 1
	player.notify_crafting()
