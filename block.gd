const CAT_DIRT = 0
const CAT_ROCK = 1
const CAT_WOOD = 2
const CAT_SPECIAL = 3

const GRASS = 0
const DIRT = 1
const ROCK = 2
const WOOD = 3
const COAL = 4
const COPPER_ORE = 5
const SPECIAL = 6
const SPAWN = 7
const BRICK = 8
const PLATFORM = 9

const COPPER_BAR = 12

const CRAFT_TABLE = -2
const WOOD_PICK = -3
const WOOD_AXE = -4
const WOOD_SHOVEL = -5
const FURNACE = -6
const ROCK_PICK = -7
const ROCK_AXE = -8
const ROCK_SHOVEL = -9
const TORCH = -10

const GRASS_WALL = -11
const DIRT_WALL = -12
const ROCK_WALL = -13
const WOOD_WALL = -14
const SLEDGEHAMMER = -15
const BRICK_WALL = -16

const CHEST = -17
const BLUE_FLAG = -18

#const COPPER_BAR = -19
const COPPER_PICK = -20
const COPPER_AXE = -21
const COPPER_SHOVEL = -22

const WOOD_SWORD = -23
const ROCK_SWORD = -24
const COPPER_SWORD = -25

const ENERGY_PART = -26
const JAVELIN = -27
const RED_FLAG = -28

const GRASS_WALL_TILE = -1
const DIRT_WALL_TILE = 0
const ROCK_WALL_TILE = 1
const WOOD_WALL_TILE = 2
const BRICK_WALL_TILE = 3

const icon_map = {

	0: preload("res://sprite/grass_icon.png"),
	1: preload("res://sprite/dirt_icon.png"),
	2: preload("res://sprite/rocks_icon.png"),
	3: preload("res://sprite/wood_icon.png"),
	4: preload("res://sprite/coal_icon.png"),
	5: preload("res://sprite/copper_ore_icon.png"),
	8: preload("res://sprite/brick_icon.png"),
	9: preload("res://sprite/platform_icon.png"),
	
	-2: preload("res://sprite/crafting_table_icon.png"),
	-3: preload("res://sprite/stickaxe_icon.png"),
	-4: preload("res://sprite/wood_axe_icon.png"),
	-5: preload("res://sprite/wood_shovel_icon.png"),
	-6: preload("res://sprite/furnace_icon.png"),
	-7: preload("res://sprite/rock_pick_icon.png"),
	-8: preload("res://sprite/rock_axe_icon.png"),
	-9: preload("res://sprite/rock_shovel_icon.png"),
	-10: preload("res://sprite/torch_icon.png"),
	
	-12: preload("res://sprite/dirt_wall_icon.png"),
	-13: preload("res://sprite/rocks_wall_icon.png"),
	-14: preload("res://sprite/wood_wall_icon.png"),
	
	-15: preload("res://sprite/sledgehammer_icon.png"),
	
	-16: preload("res://sprite/brick_wall_icon.png"),
	
	-17: preload("res://sprite/chest_icon.png"),
	-18: preload("res://sprite/blue_flag_icon.png"),
	COPPER_BAR: preload("res://sprite/copper_bar_icon.png"),
	
	-20: preload("res://sprite/copper_pick_icon.png"),
	-21: preload("res://sprite/copper_axe_icon.png"),
	-22: preload("res://sprite/copper_shovel_icon.png"),
	
	-23: preload("res://sprite/wood_sword_icon.png"),
	-24: preload("res://sprite/rock_sword_icon.png"),
	-25: preload("res://sprite/copper_sword_icon.png"),
	
	-26: preload("res://sprite/energy_particle_icon.png"),
	-27: preload("res://sprite/javelin_icon.png"),
	
	-28: preload("res://sprite/red_flag_icon.png"),
	
}

const texture_map = {
	0: preload("res://sprite/grass.png"),
	1: preload("res://sprite/dirt.png"),
	2: preload("res://sprite/rocks.png"),
	3: preload("res://sprite/wood.png"),
	4: preload("res://sprite/coal.png"),
	5: preload("res://sprite/copper_ore.png"),
	8: preload("res://sprite/brick.png"),
	9: preload("res://sprite/platform.png"),
	
	-2: preload("res://sprite/crafting_table_drop.png"),
	-3: preload("res://sprite/stickaxe_drop.png"),
	-4: preload("res://sprite/wood_axe_drop.png"),
	-5: preload("res://sprite/wood_shovel_drop.png"),
	-6: preload("res://sprite/furnace_drop.png"),
	-7: preload("res://sprite/rock_pick_drop.png"),
	-8: preload("res://sprite/rock_axe_drop.png"),
	-9: preload("res://sprite/rock_shovel_drop.png"),
	-10: preload("res://sprite/torch_drop.png"),
	
	-12: preload("res://sprite/dirt_wall.png"),
	-13: preload("res://sprite/rocks_wall.png"),
	-14: preload("res://sprite/wood_wall.png"),
	
	-15: preload("res://sprite/sledgehammer_drop.png"),
	
	-16: preload("res://sprite/brick_wall.png"),
	
	-17: preload("res://sprite/chest_drop.png"),
	-18: preload("res://sprite/blue_flag_drop.png"),
	COPPER_BAR: preload("res://sprite/copper_bar_drop.png"),
	
	-20: preload("res://sprite/copper_pick_drop.png"),
	-21: preload("res://sprite/copper_axe_drop.png"),
	-22: preload("res://sprite/copper_shovel_drop.png"),
	
	-23: preload("res://sprite/wood_sword_drop.png"),
	-24: preload("res://sprite/rock_sword_drop.png"),
	-25: preload("res://sprite/copper_sword_drop.png"),
	
	-26: preload("res://sprite/energy_particle_drop.png"),
	-27: preload("res://sprite/javelin_drop.png"),
	
	-28: preload("res://sprite/red_flag_drop.png"),
}

#const lore_map = {
#	0: ["Grass", "Is always greener on the other side"],
#	1: ["Dirt", "Not much you can do with this..."],
#	2: ["Rocks", "Surprisingly easy to shape by hand"],
#	3: ["Wood", "All-natural"],
#	4: ["Coal", "You can light these rocks on fire"],
#	5: ["Copper ore", "Something useful for once"],
#
#	-2: ["Crafting table", "You become craftier in the presence of this table"],
#	-3: ["Stickaxe", "A pickaxe made out of sticks"],
#	-4: ["Wood axe", "Chop down trees using a tree"],
#	-5: ["Wood shovel", "Easier than using your hands"],
#	-6: ["Furnace", "Nothing ever burns down by itself"],
#	-7: ["Rock pick", "Breaks stuff better"],
#	-8: ["Rock axe", "Chopin"],
#	-9: ["Rock shovel", "Now you can dig even faster! Perfect, right?"]
#}

const lore_map = {
	0: ["Grass", "Grows on the top of the world"],
	1: ["Dirt", "Not much you can do with this..."],
	2: ["Rocks", "Abundant material with some uses"],
	3: ["Wood", "Material from trees. Can make tools"],
	4: ["Coal", "Plentiful fuel source"],
	5: ["Copper ore", "Common metal ore"],
	8: ["Brick", "Building material from Red Team's base"],
	9: ["Platform", "You can jump up through these or fall through by holding the down key"],

	-2: ["Crafting table", "Lets you craft fancier stuff"],
	-3: ["Stickaxe", "A pickaxe made out of sticks"],
	-4: ["Wood axe", "Some improvement to woodcutting speed"],
	-5: ["Wood shovel", "Good improvement to digging speed"],
	-6: ["Furnace", "Lets you smelt ores and make charcoal"],
	-7: ["Rock pick", "Some improvement to mining speed"],
	-8: ["Rock axe", "Some improvement to woodcutting speed"],
	-9: ["Rock shovel", "Good improvement to digging speed"],
	-10: ["Torch", "Lets you see better"],
	
	-12: ["Dirt wall", "Place in the background for a boring dirt wall"],
	-13: ["Rock wall", "Place in the background for a nice stone wall"],
	-14: ["Wood wall", "Place in the background for an endearing wood wall"],
	
	-15: ["Sledgehammer", "Allows you to break walls"],
	-16: ["Brick wall", "Place in the background for a crimson brick wall"],
	
	-17: ["Chest", "Place to store extra items"],
	-18: ["Blue flag", "Swing to teleport home. Does not work when carrying red flag"],
	COPPER_BAR: ["Copper bar", "Used to make copper tools"],
	
	-20: ["Copper pick", "Good improvement to mining speed"],
	-21: ["Copper axe", "Good improvement to woodcutting speed"],
	-22: ["Copper shovel", "Good improvement to digging speed"],
	
	-23: ["Wood sword", "Does 2 damage to enemies"],
	-24: ["Rock sword", "Does 3 damage to enemies"],
	-25: ["Copper sword", "Does 5 damage to enemies"],
	
	-26: ["Energy particle", "Heals one-half heart"],
	-27: ["Javelin", "Throw to do 2 damage to enemies"],
	
	-28: ["Red flag", "Take this back to your base to win!"],
}



static func wall_tile(item_id):
	if item_id == DIRT_WALL:
		return DIRT_WALL_TILE
	if item_id == ROCK_WALL:
		return ROCK_WALL_TILE
	if item_id == WOOD_WALL:
		return WOOD_WALL_TILE
	if item_id == BRICK_WALL:
		return BRICK_WALL_TILE
		
static func wall_item(wall_id):
	if wall_id == DIRT_WALL_TILE:
		return DIRT_WALL
	if wall_id == ROCK_WALL_TILE:
		return ROCK_WALL
	if wall_id == WOOD_WALL_TILE:
		return WOOD_WALL
	if wall_id == BRICK_WALL_TILE:
		return BRICK_WALL

static func tiles(id):
	if id == -1:
		return 1
	if id == 0:
		return 64
	if id == 1:
		return 64
	if id == 2:
		return 64
	if id == 3:
		return 4
	if id == 4:
		return 16
	if id == 5:
		return 64
	if id == DIRT_WALL or id == ROCK_WALL:
		return 64
	if id == WOOD_WALL:
		return 4
	if id == BRICK:
		return 4
	if id == BRICK_WALL:
		return 4
	if id == PLATFORM:
		return 1
	if id == COPPER_BAR:
		return 8
		
static func is_wall(id):
	return id == DIRT_WALL or id == ROCK_WALL or id == WOOD_WALL or id == BRICK_WALL

static func get_icon(id):
	return icon_map.get(id)
	
static func get_texture(id):
	return texture_map.get(id)
	
static func item_name(id):
	if id in lore_map:
		return lore_map.get(id)[0]
	return "ERROR"
	
static func item_description(id):
	if id in lore_map:
		return lore_map.get(id)[1]
	return "ERROR"
	
static func is_block(id):
	if id == WOOD_WALL or id == ROCK_WALL or id == DIRT_WALL or id == BRICK_WALL:
		return true
	return id >= 0
	
static func is_placeable(id):
	return id >= 0
	
static func is_stackable(id):
	if id == TORCH:
		return true
	if id == DIRT_WALL:
		return true
	if id == ROCK_WALL:
		return true
	if id == WOOD_WALL:
		return true
	if id == BRICK_WALL:
		return true
	if id == COPPER_BAR:
		return true
	if id == ENERGY_PART or id == JAVELIN:
		return true
	return id >= -1
	
static func is_item(id):
	return id < -1
	
static func category(id):
	if id == 0: return CAT_DIRT
	if id == 1: return CAT_DIRT
	if id == 2: return CAT_ROCK
	if id == 3: return CAT_WOOD
	if id == COAL: return CAT_ROCK
	if id == COPPER_ORE: return CAT_ROCK
	if id == SPECIAL: return CAT_SPECIAL
	
	if id == COPPER_BAR: return CAT_ROCK
	
	if id == BRICK: return CAT_ROCK
	
	if id == DIRT_WALL: return CAT_DIRT
	if id == WOOD_WALL: return CAT_WOOD
	if id == ROCK_WALL: return CAT_ROCK
	if id == BRICK_WALL: return CAT_ROCK
	return CAT_ROCK

static func wood_strength(id):
	if id == COPPER_AXE:
		return 2.3
	if id == ROCK_AXE:
		return 1.8
	if id == -4:
		# ok early axe
		return 1.5
	return 1
	
static func rock_strength(id):
	if id == COPPER_PICK:
		return 10.0#1.7
	if id == ROCK_PICK:
		return 1.3
	if id == -3:
		# we used to use 5 here because 1/0.2 = 5. but these aren't multiplied so don't od that
		return 1.1
	# rocks are slow without a pick
	return 0.2
	
static func dirt_strength(id):
	if id == COPPER_SHOVEL:
		return 4.5
	if id == ROCK_SHOVEL:
		return 3.5
	if id == -5:
		# early shovel boost
		return 2.5
	
	return 1
	
static func damage(id):
	if id == WOOD_SWORD:
		return 2
	if id == ROCK_SWORD:
		return 3
	if id == COPPER_SWORD:
		return 5
	return 1
	
# in case we want to make a really slow block
# use e.g. 0.5
# to make block faster do 2.0 or something
static func block_slowdown(id):
	if id == PLATFORM:
		return 5.0
	return 1
