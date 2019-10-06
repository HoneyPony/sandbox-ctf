extends Area2D

# NOTE TO SELF:
# The collision layer bit for this thing can be used for other crafting stations
# if we really need them.

const CRAFTING = 0
const FURNACE = 1

var player
export var mode = 0

func _ready():
	player = get_node("/root/root/player")

func player_enter(body):
	if mode == CRAFTING:
		# If I were smart I would just modify the body crafting table # but oh well
		player.crafting_tables += 1
	if mode == FURNACE:
		player.furnaces += 1
	player.notify_crafting()


func player_exit(body):
	if mode == CRAFTING:
		player.crafting_tables -= 1
	if mode == FURNACE:
		player.furnaces -= 1
	player.notify_crafting()
