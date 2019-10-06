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
	
	func _init(output_, output_count_, input1_, input1_count_, input2_ = -1, input2_count_ = 0, input3_ = -1, input3_count_ = 0):
		output = output_
		output_count = output_count_
		
		input1 = input1_
		input1_count = input1_count_
		
		input2 = input2_
		input2_count = input2_count_
		
		input3 = input3_
		input3_count = input3_count_
	
var items: Array

var floating_item

var active_hotbar = 0

var recipes = [
	Recipe.new(3, 5, 0, 1),
	Recipe.new(2, 5, 0, 1),
	Recipe.new(3, 5, 0, 1),
	Recipe.new(2, 5, 0, 1),
	Recipe.new(3, 5, 0, 1),
	Recipe.new(2, 5, 0, 1),
	Recipe.new(3, 5, 0, 1),
	Recipe.new(2, 5, 0, 1),
	Recipe.new(3, 5, 0, 1),
	Recipe.new(2, 5, 0, 1)
]


func active_item():
	return items[active_hotbar]

func _init():
	floating_item = Item.new()
	for i in range(0, 40):
		items.append(Item.new())
		
func check_recipe(recipe):
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
	if floating_item.id != -1:
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
	floating_item.count = recipe.output_count
	
	return check_recipe(recipe)
			
# Returns whether there is a floating item.
func float_slot(slot):
	# Merge for same type (TODO IF STACKABLE)
	if floating_item.id == items[slot].id:
		items[slot].count += floating_item.count
		floating_item.count = 0
		floating_item.id = -1
		return false
	
	var fid = floating_item.id
	var fc = floating_item.count
	
	floating_item.id = items[slot].id
	floating_item.count = items[slot].count
	
	items[slot].id = fid
	items[slot].count = fc
	
	return floating_item.id != -1
	
# Returns whether mouse should need to be re-clicked
func split_slot(slot):
	if floating_item.id == -1:
		var slot_count = int(floor(items[slot].count / 2))
		var float_count = items[slot].count - slot_count
		floating_item.id = items[slot].id
		floating_item.count = float_count
		items[slot].count = slot_count
		if slot_count == 0:
			items[slot].id = -1
		return true
		
	if floating_item.id != items[slot].id && items[slot].id != -1:
		float_slot(slot)
		return true
		
	# in case items[slot] was -1
	items[slot].id = floating_item.id
	
	# ids are now guaranteed same
	floating_item.count -= 1
	items[slot].count += 1
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