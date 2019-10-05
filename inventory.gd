class Item:
	var id: int = -1
	var count: int = 0
	
var items: Array

func _init():
	for i in range(0, 39):
		items.append(Item.new())
		
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