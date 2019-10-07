extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var break_map: TileMap
var block_map: TileMap
var physics_map: TileMap
var platform_map: TileMap

var wall_map: TileMap

var player

var base_block_time = 0.111111

var block_time = 0.1

var block_timer = 0

var item_pickup

var Block = preload("res://block.gd")

const HIT_DIRT = 0
const HIT_ROCK = 1
const HIT_WOOD = 2
const HIT_NOTHING = 3
const PLACE = 4

var next_audio = HIT_NOTHING

func consume_audio():
	if next_audio == HIT_DIRT:
		$hit_dirt.play()
	if next_audio == HIT_ROCK:
		$hit_rock.play()
	if next_audio == HIT_WOOD:
		$hit_wood.play()
	if next_audio == HIT_NOTHING:
		$hit_nothing.play()
	if next_audio == PLACE:
		$place.play()
	next_audio = HIT_NOTHING
	pass

func audio_cat(id):
	var cat = Block.category(id)
	if cat == Block.CAT_DIRT:
		next_audio = HIT_DIRT
	elif cat == Block.CAT_ROCK:
		next_audio = HIT_ROCK
	elif cat == Block.CAT_WOOD:
		next_audio = HIT_WOOD
	else:
		next_audio = HIT_WOOD

func snap_number(num, count):
		var res = int(num) % count
		if res < 0: res += count
		return res
		
func autotile(x, y, id):
	var number = Block.tiles(id)
	x = snap_number(x, number)
	y = snap_number(y, number)
	return Vector2(x, y)

# Called when the node enters the scene tree for the first time.
func _ready():
	break_map = get_node("/root/root/block_break_viewport/block_break_map")
	block_map = get_node("/root/root/tiles")
	physics_map = get_node("/root/root/physics_map")
	platform_map = get_node("/root/root/platform_map")
	item_pickup = load("res://item_pickup.tscn")
	
	wall_map = get_node("/root/root/walls")
	
	player = get_node("/root/root/player")
	pass # Replace with function body.
	
func tile_x():
	return round((position.x - 2) / 4)
	
func tile_y():
	return round((position.y - 2) / 4)
	
func break_wall():
	var x = tile_x()
	var y = tile_y()
	if wall_map.get_cell(x, y) == -1:
		return
		
	var wall_id = wall_map.get_cell(x, y)
	wall_map.set_cell(x, y, -1)
	
	var id = Block.wall_item(wall_id)
		
	var pickup = item_pickup.instance()
	get_node("/root/root").add_child(pickup)
	pickup.position = Vector2(x, y) * 4 + Vector2(2, 2)
	pickup.set_id(id)
	
	audio_cat(id)
	
func break_block():
	if player.inventory.active_item().id == Block.SLEDGEHAMMER:
		break_wall()
		return
	
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) == -1:
		return
		
	if block_map.get_cell(x, y) == Block.SPAWN:
		return
		
	if break_map.get_cell(x, y) == -1:
		break_map.set_cell(x, y, 0)
		audio_cat(block_map.get_cell(x, y))
		return
		
	if block_timer < block_time:
		return
		
	block_timer = 0
	
	var progress = break_map.get_cell_autotile_coord(x, y).x
		
	audio_cat(block_map.get_cell(x, y))
	if progress == 9:
		var id = block_map.get_cell(x, y)
		
		if id == Block.SPECIAL:
			var closest = null
			for n in get_tree().get_nodes_in_group("special"):
				if n.is_at(x, y):
					closest = n
					
			if closest != null:
				x = round(closest.position.x / 4)
				y = round(closest.position.y / 4)
				id = closest.tile_destroy(block_map, x, y)
				closest.tile_destroy(break_map, x, y)
				closest.tile_destroy(physics_map, x, y) # we're still using physics_map sadly
				closest.tile_destroy(platform_map, x, y) # is this necessary?
				closest.get_parent().remove_child(closest)
			else:
				return
				
		else:
			# Make sure physics will work
			if block_map.get_cell(x, y + 1) != -1:
				physics_map.set_cell(x, y + 1, 0)
			
			break_map.set_cell(x, y, -1)
			block_map.set_cell(x, y, -1)
			physics_map.set_cell(x, y, -1)
			platform_map.set_cell(x, y, -1)
		
		var pickup = item_pickup.instance()
		get_node("/root/root").add_child(pickup)
		pickup.position = Vector2(x, y) * 4 + Vector2(2, 2)
		pickup.set_id(id)
		
		return
		
	break_map.set_cell(x, y, 0, false, false, false, Vector2(progress + 1, 0))
		
	
func place_wall():
	var x = tile_x()
	var y = tile_y()
	if wall_map.get_cell(x, y) != -1:
		return
	
	var id = player.inventory.active_item().id
	if player.inventory.consume():
		wall_map.set_cell(x, y, Block.wall_tile(id), false, false, false, autotile(x, y, id))
		next_audio = PLACE
	
func place_block():
	if player.current_chest != null:
		# Don't place when opening chest
		return
	
	var distance = (position - player.position).length()
	if distance > 4 * 14:
		return
		
	if Block.is_wall(player.inventory.active_item().id):
		place_wall()
		return
	
	# crafting table
	if player.inventory.active_item().id == -2:
		crafting_table()
		return
		
	if player.inventory.active_item().id == -6:
		furnace()
		return
		
	if player.inventory.active_item().id == Block.TORCH:
		torch()
		return
		
	if player.inventory.active_item().id == Block.CHEST:
		chest()
		return
		
	if !Block.is_placeable(player.inventory.active_item().id):
		return
	
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) != -1:
		return
		
	var on_ground = false
		
	if wall_map.get_cell(x, y) != -1:
		on_ground = true
		
	if block_map.get_cell(x + 1, y) != -1:
		on_ground = true
	if block_map.get_cell(x - 1, y) != -1:
		on_ground = true
	if block_map.get_cell(x, y + 1) != -1:
		on_ground = true
	if block_map.get_cell(x, y - 1) != -1:
		on_ground = true
		
	if !on_ground:
		return
	
	var id = player.inventory.active_item().id
	if player.inventory.consume():
		block_map.set_cell(x, y, id, false, false, false, autotile(x, y, id))
		if id == Block.PLATFORM:
			platform_map.set_cell(x, y, 0)
		else:
			physics_map.set_cell(x, y, 0)
		next_audio = PLACE

func torch():
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) != -1:
		return
		
	var on_ground = false
	
	if wall_map.get_cell(x, y) != -1:
		on_ground = true
		
	if block_map.get_cell(x + 1, y) != -1:
		on_ground = true
	if block_map.get_cell(x - 1, y) != -1:
		on_ground = true
	if block_map.get_cell(x, y + 1) != -1:
		on_ground = true
	if block_map.get_cell(x, y - 1) != -1:
		on_ground = true
		
	if !on_ground:
		return
		
	if player.inventory.consume():
		var table = load("res://torch.tscn").instance()
		table.position = Vector2(x * 4, y * 4)
		get_node("/root/root").add_child(table)
		block_map.set_cell(x, y, Block.SPECIAL)
		next_audio = PLACE

func furnace():
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) != -1:
		return
	if block_map.get_cell(x + 1, y) != -1:
		return
		
	if block_map.get_cell(x, y + 1) == -1:
		return
	if block_map.get_cell(x + 1, y + 1) == -1:
		return
		
	if player.inventory.consume():
		var table = load("res://furnace.tscn").instance()
		table.position = Vector2(x * 4, y * 4)
		get_node("/root/root").add_child(table)
		block_map.set_cell(x, y, Block.SPECIAL)
		block_map.set_cell(x + 1, y, Block.SPECIAL)
		block_map.set_cell(x, y - 1, Block.SPECIAL)
		block_map.set_cell(x + 1, y - 1, Block.SPECIAL)
		next_audio = PLACE
		
func chest():
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) != -1:
		return
	if block_map.get_cell(x + 1, y) != -1:
		return
		
	if block_map.get_cell(x, y + 1) == -1:
		return
	if block_map.get_cell(x + 1, y + 1) == -1:
		return
		
	if player.inventory.consume():
		var table = load("res://chest.tscn").instance()
		table.position = Vector2(x * 4, y * 4)
		get_node("/root/root").add_child(table)
		block_map.set_cell(x, y, Block.SPECIAL)
		block_map.set_cell(x + 1, y, Block.SPECIAL)
		block_map.set_cell(x, y - 1, Block.SPECIAL)
		block_map.set_cell(x + 1, y - 1, Block.SPECIAL)
		next_audio = PLACE

func crafting_table():
	var x = tile_x()
	var y = tile_y()
	if block_map.get_cell(x, y) != -1:
		return
	if block_map.get_cell(x + 1, y) != -1:
		return
		
	if block_map.get_cell(x, y + 1) == -1:
		return
	if block_map.get_cell(x + 1, y + 1) == -1:
		return
		
	if player.inventory.consume():
		var table = load("res://crafting_table.tscn").instance()
		table.position = Vector2(x * 4, y * 4)
		get_node("/root/root").add_child(table)
		block_map.set_cell(x, y, Block.SPECIAL)
		block_map.set_cell(x + 1, y, Block.SPECIAL)
		next_audio = PLACE
		#TODO:::!!:!:!:! Make fake blocks so that everything else works smoothyl

func get_relevant_strength():
	var cat = Block.category(block_map.get_cell(tile_x(), tile_y()))
	if cat == Block.CAT_DIRT:
		return player.current_dirt()
	if cat == Block.CAT_ROCK:
		return player.current_rock()
	if cat == Block.CAT_WOOD:
		return player.current_wood()
	if cat == Block.CAT_SPECIAL:
		return 9
	# Fallback
	return player.current_rock()
	
func get_total_speedup():
	return get_relevant_strength() * Block.block_slowdown(block_map.get_cell(tile_x(), tile_y()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x1 = tile_x()
	var y1 = tile_y()
	position = get_global_mouse_position()
	
	block_time = base_block_time / get_total_speedup()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if tile_x() != x1:
			block_timer = 0
		if tile_y() != y1:
			block_timer = 0
		break_block()
	else:
		block_timer = 0
		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		place_block()
		
	block_timer += delta
	
	# Uncomment for cursor display
	#position.x = tile_x() * 4 + 2
	#position.y = tile_y() * 4 + 2
