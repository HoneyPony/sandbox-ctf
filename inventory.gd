class Item:
	var id: int = -1
	var count: int = 0
	
	func is_block():
		return true
	
var items: Array

var floating_item

var active_hotbar = 0

func active_item():
	return items[active_hotbar]

func _init():
	floating_item = Item.new()
	for i in range(0, 40):
		items.append(Item.new())
		
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