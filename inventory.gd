class Item:
	var id: int = -1
	var count: int = 0
	
	func is_block():
		return true
	
var items: Array

var active_hotbar = 0

func active_item():
	return items[active_hotbar]

func _init():
	for i in range(0, 39):
		items.append(Item.new())
		
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