#TODO: Bug is caused by hovering over item when closing inventory

class Item:
	var id: int = -1
	var count: int = 0
	
	func is_block():
		return true
		
class Recipe:
	var output: int = 0
	var output_count: int = 1
	
	var input1: int = 0
	var input1_count: int = 1
	
	var input2: int = 0
	var input2_count: int = 1
	
	var input3: int = 0
	var input3_count: int = 1
	
	var requires_table: bool = false
	var requires_furnace: bool = false
	
	func _init(output_, output_count_, input1_, input1_count_, input2_ = -1, input2_count_ = 0, input3_ = -1, input3_count_ = 0):
		output = output_
		output_count = output_count_
		
		input1 = input1_
		input1_count = input1_count_
		
		input2 = input2_
		input2_count = input2_count_
		
		input3 = input3_
		input3_count = input3_count_
		
	func table():
		requires_table = true
		return self
		
	func furnace():
		requires_furnace = true
		return self
	
var items: Array

var floating_item

var active_hotbar = 0

var player
var Block = preload("res://block.gd")

var recipes = [
	Recipe.new(-2, 1, 3, 10),
	Recipe.new(-3, 1, 3, 10).table(), # pick
	Recipe.new(-4, 1, 3, 9).table(), # axe
	Recipe.new(-5, 1, 3, 8).table(), # shovel
	Recipe.new(Block.WOOD_SWORD, 1, 3, 10).table(),
	Recipe.new(-6, 1, 2, 10, 4, 5, 3, 5),
	Recipe.new(4, 1, 3, 5).furnace(), # charcoal
	
	Recipe.new(Block.TORCH, 4, Block.COAL, 1, Block.WOOD, 1),
	
	Recipe.new(Block.ROCK_PICK, 1, Block.WOOD, 5, Block.ROCK, 5).table(),
	Recipe.new(Block.ROCK_AXE, 1, Block.WOOD, 5, Block.ROCK, 4).table(),
	Recipe.new(Block.ROCK_SHOVEL, 1, Block.WOOD, 5, Block.ROCK, 3).table(),
	Recipe.new(Block.ROCK_SWORD, 1, Block.WOOD, 5, Block.ROCK, 5).table(),
	
	Recipe.new(Block.SLEDGEHAMMER, 1, Block.WOOD, 5, Block.ROCK, 5).table(),
	
	Recipe.new(Block.COPPER_BAR, 1, Block.COPPER_ORE, 2).furnace(),
	
	Recipe.new(Block.COPPER_PICK, 1, Block.WOOD, 5, Block.COPPER_BAR, 5).table(),
	Recipe.new(Block.COPPER_AXE, 1, Block.WOOD, 5, Block.COPPER_BAR, 4).table(),
	Recipe.new(Block.COPPER_SHOVEL, 1, Block.WOOD, 5, Block.COPPER_BAR, 3).table(),
	Recipe.new(Block.COPPER_SWORD, 1, Block.WOOD, 5, Block.COPPER_BAR, 5).table(),
	
	Recipe.new(Block.DIRT_WALL, 4, Block.DIRT, 1).table(),
	Recipe.new(Block.ROCK_WALL, 4, Block.ROCK, 1).table(),
	Recipe.new(Block.WOOD_WALL, 4, Block.WOOD, 1).table(),
	Recipe.new(Block.BRICK_WALL, 4, Block.BRICK, 1).table(),
	
	Recipe.new(Block.DIRT, 1, Block.DIRT_WALL, 4).table(),
	Recipe.new(Block.ROCK, 1, Block.ROCK_WALL, 4).table(),
	Recipe.new(Block.WOOD, 1, Block.WOOD_WALL, 4).table(),
	Recipe.new(Block.BRICK, 1, Block.BRICK_WALL, 4).table(),
	
	Recipe.new(Block.CHEST, 1, Block.WOOD, 10).table()
	
]

func active_item():
	return items[active_hotbar]

func give_self_debug(where, id, count = 1):
	items[where].id = id
	items[where].count = count

func _init(player_):
	player = player_
	floating_item = Item.new()
	for i in range(0, 40):
		items.append(Item.new())
	
	give_self_debug(9, Block.BLUE_FLAG, 1)
		
func check_recipe(recipe):
	if recipe.requires_table and not player.at_crafting_table:
		return false
		
	if recipe.requires_furnace and not player.at_furnace:
		return false
	
	var id1 = 0
	var id2 = 0
	var id3 = 0
	
	for slot in range(0, 40):
		if items[slot].id == recipe.input1:
			id1 += items[slot].count
		if items[slot].id == recipe.input2:
			id2 += items[slot].count
		if items[slot].id == recipe.input3:
			id3 += items[slot].count
			
	return id1 >= recipe.input1_count and id2 >= recipe.input2_count and id3 >= recipe.input3_count
	
# Returns whether you can make another of the same recipe.
func make_recipe(recipe):
	# Don't make if we're already floating (TODO: make another?)
	if floating_item.id != -1 and floating_item.id != recipe.output or not Block.is_stackable(floating_item.id):
		return true
		
	if !check_recipe(recipe):
		return false
		
	var id1 = recipe.input1_count
	var id2 = recipe.input2_count
	var id3 = recipe.input3_count
		
	for slot in range(0, 40):
		if items[slot].id == recipe.input1:
			if items[slot].count > id1:
				items[slot].count -= id1
				id1 = 0
			else:
				id1 -= items[slot].count
				items[slot].count = 0
				items[slot].id = -1
		if items[slot].id == recipe.input2:
			if items[slot].count > id2:
				items[slot].count -= id2
				id2 = 0
			else:
				id2 -= items[slot].count
				items[slot].count = 0
				items[slot].id = -1
		if items[slot].id == recipe.input3:
			if items[slot].count > id3:
				items[slot].count -= id3
				id3 = 0
			else:
				id3 -= items[slot].count
				items[slot].count = 0
				items[slot].id = -1
	
	floating_item.id = recipe.output
	if floating_item.id == recipe.output:
		floating_item.count += recipe.output_count
	else:
		floating_item.count = recipe.output_count
		
	return check_recipe(recipe)
			
# Returns whether there is a floating item.
func float_slot(slot, use_chest = false):
	
	var item_ref = items
	if use_chest:
		item_ref = player.current_chest.items
	
	# Merge for same type (TODO IF STACKABLE)
	if floating_item.id == item_ref[slot].id and Block.is_stackable(floating_item.id):
		item_ref[slot].count += floating_item.count
		floating_item.count = 0
		floating_item.id = -1
		return false
	
	var fid = floating_item.id
	var fc = floating_item.count
	
	floating_item.id = item_ref[slot].id
	floating_item.count = item_ref[slot].count
	
	item_ref[slot].id = fid
	item_ref[slot].count = fc
	
	return floating_item.id != -1
	
# Returns whether mouse should need to be re-clicked
func split_slot(slot, use_chest = false):
	var item_ref = items
	if use_chest:
		item_ref = player.current_chest.items
	
	if not Block.is_stackable(floating_item.id) or not Block.is_stackable(item_ref[slot].id):
		float_slot(slot)
		return true
	
	if floating_item.id == -1:
		var slot_count = int(floor(item_ref[slot].count / 2))
		var float_count = item_ref[slot].count - slot_count
		floating_item.id = item_ref[slot].id
		floating_item.count = float_count
		item_ref[slot].count = slot_count
		if slot_count == 0:
			item_ref[slot].id = -1
		return true
		
	if floating_item.id != item_ref[slot].id && item_ref[slot].id != -1:
		float_slot(slot)
		return true
		
	# in case item_ref[slot] was -1
	item_ref[slot].id = floating_item.id
	
	# ids are now guaranteed same
	floating_item.count -= 1
	item_ref[slot].count += 1
	if floating_item.count == 0:
		floating_item.id = -1
		
	return floating_item.id == -1
	
		
func consume():
	if active_item().is_block():
		if active_item().count > 0:
			active_item().count -= 1
			if active_item().count == 0:
				active_item().id = -1
			return true
	return false
		
func accept(id):
	if Block.is_stackable(id):
		# try to stack
		for item in items:
			if item.id == id:
				item.count += 1
				return true
			
	for item in items:
		if item.id == -1:
			item.id = id
			item.count = 1
			return true
			
	return false