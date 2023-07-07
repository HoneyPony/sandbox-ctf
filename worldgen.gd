extends TileMap

var GRASS = 0
var DIRT = 1
var ROCK = 2
var COAL = 4

var BRICK = 8
var PLATFORM = 9

var physics_map
var platform_map

var Tree

var Block = preload("res://block.gd")

var walls

var X_BOUND = 300
var Y_BOUND = 350

# Reduced bounds for browswer test
#var X_BOUND = 100
#var Y_BOUND = 120

func put_chest(x, y, items):
	var table = load("res://chest.tscn").instance()
	global.root.call_deferred("add_child", table)
	table.position = Vector2(round(x * 4), round(y * 4))
	set_cell(x, y, Block.SPECIAL)
	set_cell(x + 1, y, Block.SPECIAL)
	set_cell(x, y - 1, Block.SPECIAL)
	set_cell(x + 1, y - 1, Block.SPECIAL)
	
	var chest = table.get_node("sprite")
	
	var slot = 0
	
	for i in items:
		var arr: Array = i
		chest.items[slot].id = int(i[0])
		chest.items[slot].count = int(i[1])
	

func snap_number(num, count):
	var res = int(num) % count
	if res < 0: res += count
	return res

func handle(x, y, id):
	if id == 10 or id == 11:
		return Vector2(0, 0)
	var n = Block.tiles(id)
	return Vector2(snap_number(x, n), snap_number(y, n))

func plot_wall(x, y, id):
	walls.set_cell(x, y, Block.wall_tile(id), false, false, false, handle(x, y, id))

func plot(x, y, id):
	set_cell(x, y, id, false, false, false, handle(x, y, id))
	if id == Block.DIRT and y < 100:
		plot_wall(x, y, Block.DIRT_WALL)
	
func rand(a, b):
	return round(rand_range(a, b))
	
func raycast(sx, sy, ex, ey, x, rays, raye):
	# never hit vertical lines
	if ex == sx:
		return false
		
	if x < sx or x > ex:
		return false
	
	var m = (ey - sy) / (ex - sx)
	var y = m * (x - sx) + sy
#	if sy == 0 && ey == 0:
#		print(x, " ", rays, " ", raye, " ", y, " -> ", y >= rays and y < raye)
#		print("line: ", sx, ", ", ex, " -> ", sy, ", ", ey, " m = ", m)
	return y >= rays and y < raye
	
func raycast_helper(sx, sy, ex, ey, x, rays, raye):
	#print('goin from ', sy, ' to ', ey)
	var tsx = sx
	var tsy = sy
	var tex = ex
	var tey = ey
	if sx > ex:
		tex = sx
		tsx = ex
		tsy = ey
		tey = sy
	return raycast(tsx, tsy, tex, tey, x, rays, raye)
	
func raycast_all(points, x, y0, y):
	var flip = false
	for i in range(points.size() - 1):
		var a = points[i]
		var b = points[i + 1]
		if raycast_helper(a.x, a.y, b.x, b.y, x, y0, y):
			flip = !flip
	var a = points[points.size() - 1]
	var b = points[0]
	if raycast_helper(a.x, a.y, b.x, b.y, x, y0, y):
		flip = !flip
	return flip
	
func fill_poly(points: Array, type, noisy = false):
	var xmin = points[0].x
	var xmax = points[0].x
	var ymin = points[0].y
	var ymax = points[0].y
	for p in points:
		if p.x < xmin:
			xmin = p.x
		if p.x > xmax:
			xmax = p.x
		if p.y < ymin:
			ymin = p.y
		if p.y > ymax:
			ymax = p.y
			
	ymin -= 1
	xmin = floor(xmin)
	xmax = ceil(xmax)
	ymin = floor(ymin)
	ymax = ceil(ymax)
			
	var filling = false
	for x in range(xmin, xmax + 1):
		filling = false
		var y0 = ymin
		for y in range(ymin, ymax + 1):
			if raycast_all(points, x, y0, y):
				filling = !filling
				if noisy and filling:
					if rand(0, 1) == 0:
						plot(x, y - 1, type)
				if noisy and !filling:
					if rand(0, 1) == 0:
						plot(x, y, type)
				#print("switch at ", y0, " -> ", y)
			y0 = y
			if filling:
				plot(x, y, type)
				
var last_tree = -X_BOUND
var last_run = -10000
var tree_run = 0

func finish_tree(x, y):
	var t = Tree.instance()
	t.position = Vector2(x * 4, (y + 1) * 4)
	global.root.call_deferred("add_child", t)

func tree(x, y):
	# somehow we were getting floats before.....
	x = round(x)
	y = round(y)
	
	if tree_run > 0:
		if x - last_tree > 10 and rand(0, 7) == 0:
			tree_run -= 1
			last_tree = x
			last_run = x
			finish_tree(x, y)
	else:
		if x - last_run > 30 and rand(0, 8) == 0:
			tree_run = rand(6, 21)
			last_tree = x
			finish_tree(x, y)
				
func grass(x, y):
	for a in range(0, rand(3, 4)):
		plot(x, y + a, GRASS)
	tree(x, y - 1)
		
				
func hill(s):
	var width = rand(15, 37)
	var height = rand(5, width / 1.9)
	var delta = rand(-5, 10)
	
	if s.y - delta > 5:
		delta = (5 - s.y)
		
	if s.y - delta < -40:
		delta = -40 - s.y
	
	if s.x + width > X_BOUND:
		width = X_BOUND - s.x
	
	for x in range(0, width + 1):
		var z = (2 * x - width) / width
		var y = -( (2 * height * (0.5 - ((z * z) / 2)) + (delta * x / width)) )
		
		for a in range(s.y + y, 0):
			plot(s.x + x, a, DIRT)
		grass(s.x + x, s.y + y)

	return [Vector2(s.x + width, s.y - delta), [0, 0, 0, 0, 4, 4, 4, 3, 3]]
	
func left_cliff(s):
	var height = rand(-5, -10)
	var width = rand(6, 13)
	
	if s.y + height > 0:
		height = 0 - s.y
	
	if s.y + height < -40:
		height = -40 - s.y
		
	if s.x + width > X_BOUND:
		width = X_BOUND - s.x
		
	var type = GRASS
	
	for x in range(0, width + 1):
		
		var delta = 0
		if x < width / 2:
			delta = -1
			
		if x >= 3:
			type = DIRT

		for a in range(s.y + height + delta, s.y + 3):
			plot(s.x + x, a, type)
		for a in range(s.y + 3, 0):
			plot(s.x + x, a, DIRT)
		grass(s.x + x, s.y + height + delta)
		
	return [Vector2(s.x + width, s.y + height), [0, 0, 1, 1, 1, 4, 4]]
	
func right_cliff(s):
	var height = rand(5, 10)
	var width = rand(6, 13)
	
	if s.y + height > 0:
		height = 0 - s.y
	
	if s.y + height < -40:
		height = -40 - s.y
		
	if s.x + width > X_BOUND:
		width = X_BOUND - s.x
		
	var type = DIRT
	
	for x in range(0, width + 1):
		
		var delta = 0
		if x > width / 2:
			delta = -1
			
		if x > width - 3:
			type = GRASS

		for a in range(s.y + delta, s.y + height + 3):
			plot(s.x + x, a, type)
		for a in range(s.y + height + 3, 0):
			plot(s.x + x, a, DIRT)
		grass(s.x + x, s.y + delta)
		
	return [Vector2(s.x + width, s.y + height), [0, 4]]
	
func flat(s):
	var width = rand(15, 30)
	
	var delta = 0
	
	if s.x + width > X_BOUND:
		width = X_BOUND - s.x
	
	for x in range(0, width + 1):
		if rand(0, 2) == 2:
			delta += rand(-1, 1)
		if s.y + delta < -40:
			delta = -40 - s.y
		if s.y + delta > 0:
			delta = 0 - s.y
		for a in range(s.y + delta, 0):
			plot(s.x + x, a, DIRT)
		grass(s.x + x, s.y + delta)
			
	return [Vector2(s.x + width, s.y + delta), [0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4]]
	
func bumpy(s):
	var width = rand(15, 30)
	
	var delta = 0
	
	if s.x + width > X_BOUND:
		width = X_BOUND - s.x
	
	for x in range(0, width + 1):
		if rand(0, 2) == 2:
			delta += rand(-2, 2)
		if s.y + delta < -40:
			delta = -40 - s.y
		if s.y + delta > 0:
			delta = 0 - s.y
		for a in range(s.y + delta, 0):
			plot(s.x + x, a, DIRT)
		grass(s.x + x, s.y + delta)
			
	return [Vector2(s.x + width, s.y + delta), [0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 4]]
	
func ground(kind, s):
	if kind == 0:
		return flat(s)
	if kind == 1:
		return hill(s)
	if kind == 2:
		return left_cliff(s)
	if kind == 3:
		return right_cliff(s)
	if kind == 4:
		return bumpy(s)
		
func connected(x, y):
	if get_cell(x - 1, y) != -1:
		return true
	if get_cell(x + 1, y) != -1:
		return true
	if get_cell(x, y - 1) != -1:
		return true
	if get_cell(x, y + 1) != -1:
		return true
	return false
		
func ground_coal(x, ty, depth = 5):
	var y = -40
	while get_cell(x, y) == -1:
		y += 1
		
	y += rand(depth, depth + 2)
		
	var r = rand(2, 4)
	for xs in range(-r, r):
		for ys in range(-r, r):
			if (xs * xs + ys * ys) < (r * r):
				var xv = xs + x
				var yv = ys + y
				if get_cell(xv, yv) != -1:
					if rand(0, 1) == 0:
						plot(xv, yv, ty)
				elif connected(xv, yv) and rand(0, 2) == 0:
					plot(xv, yv, ty)
					
func underground_ore(x, y, ty, small = 6, large = 20):
	var r = rand(small, large)
	for xs in range(-r, r):
		for ys in range(-r, r):
			if (xs * xs + ys * ys) < (r * r):
				var xv = xs + x
				var yv = ys + y
				if get_cell(xv, yv) != -1:
					if rand(0, 1) == 0:
						plot(xv, yv, ty)
				elif connected(xv, yv) and rand(0, 2) == 0:
					plot(xv, yv, ty)
					
func line_eval(p1, p2, y):
	if p1.x == p2.x:
		return p1.x # not actually necessary
		
	var m = (p2.x - p1.x) / (p2.y - p1.y)
	return m * (y - p1.y) + p1.x
					
func flat_triangle(p1, p2, ptop, type):
	if(p1.y == ptop.y):
		return
		
	var sy = p1.y
	var ey = ptop.y
	
	if sy > ey:
		var tmp = ey
		ey = sy
		sy = tmp
		
	sy = floor(sy)
	ey = ceil(ey)
	
	for y in range(sy, ey + 1):
		var sx = line_eval(p1, ptop, y)
		var ex = line_eval(p2, ptop, y)
		
		if sx > ex:
			var tmp = ex
			ex = sx
			sx = tmp
		
		sx = floor(sx)
		ex = ceil(ex)
		
		for x in range(sx, ex + 1):
			plot(x, y, type)
			
class VectorSortY:
	static func sort(a, b):
		return a.y < b.y

			
func triangle(p1, p2, p3, type):
	if p1.y == p2.y:
		flat_triangle(p1, p2, p3, type)
		return
	if p2.y == p3.y:
		flat_triangle(p2, p3, p1, type)
		return
	if p3.y == p1.y:
		flat_triangle(p3, p1, p2, type)
		return
		
	var arr = [p1, p2, p3]
	arr.sort_custom(VectorSortY, "sort")
	
	var mid_x = line_eval(arr[0], arr[2], arr[1].y)
	var mid_point = Vector2(mid_x, arr[1].y)
	
	flat_triangle(mid_point, arr[1], arr[0], type)
	flat_triangle(mid_point, arr[1], arr[2], type)
	
func quad(p1, p2, p3, p4, type):
	triangle(p1, p2, p3, type)
	triangle(p1, p3, p4, type)

func line_chunk(p1, p2, width1, width2, type):
	var delta = p2 - p1
	var ortho = Vector2(-delta.y, delta.x).normalized()
	
	width1 *= 0.5
	width2 *= 0.5
	
	quad(p1 - ortho * width1, p1 + ortho * width1, p2 + ortho * width2, p2 - ortho * width2, type)

func circle(center, radius, type):
	var sx = round(center.x - radius)
	var ex = round(center.x + radius)
	
	for x in range(sx, ex + 1):
		var t = x - center.x
		var h = sqrt(radius * radius - t * t)
		var sy = round(center.y - h)
		var ey = round(center.y + h)
		for y in range(sy, ey + 1):
			plot(x, y, type)
			
func cave_snake(x, y):
	var diameter = rand(5, 14)
	for i in range(15, 30):
		var ex = x + rand(-40, 40)
		var ey = y + rand(5, 30)
		var dr = rand(-5, 5)
		var start = Vector2(x, y)
		var end = Vector2(ex, ey)
		circle(Vector2(x, y), diameter / 2, -1)
		line_chunk(start, end, diameter, diameter + dr, -1)
		diameter += dr
		diameter = clamp(diameter, 5, 14)
		x = ex
		y = ey
	circle(Vector2(x, y), diameter / 2, -1)
	
func tower(sx, sy):
	var width = rand(4,7) * 3 - 1
	var height = rand(-40, -80)
	var platform = 1
	for y in range(sy + height, sy):
		platform -= 1
		plot(sx, y, Block.BRICK)
		plot(sx + width, y, Block.BRICK)
		var platform_width = rand(4, width - 2)
		var platform_start = rand(sx + 1, sx + width - 1 - platform_width)
		for x in range(sx + 1, sx + width):
			if platform == 0:
				if x >= platform_start and x <= platform_start + platform_width:	
					plot(x, y, Block.PLATFORM)
				else:
					plot(x, y, Block.BRICK)
			else:
				plot(x, y, -1)
			plot_wall(x, y, Block.BRICK_WALL)
		if platform == 0:
			platform = 10
			
	sy += height
			
	plot(sx - 1, sy, Block.BRICK)
	plot(sx - 2, sy - 1, Block.BRICK)
	plot(sx - 3, sy - 2, Block.BRICK)
	plot_wall(sx - 1, sy - 1, Block.BRICK_WALL)
	plot_wall(sx - 2, sy - 2, Block.BRICK_WALL)
	plot(sx + width + 1, sy, Block.BRICK)
	plot(sx + width + 2, sy - 1, Block.BRICK)
	plot(sx + width + 3, sy - 2, Block.BRICK)
	plot_wall(sx + width + 1, sy - 1, Block.BRICK_WALL)
	plot_wall(sx + width + 2, sy - 2, Block.BRICK_WALL)
	
	for x in range(sx, sx + width + 1):
		plot_wall(x, sy - 1, Block.BRICK_WALL)
		if int(x - sx) % 3 == 1:
			plot_wall(x, sy - 2, Block.BRICK_WALL)
	
	return Vector2(width, height)
	
func hallway(x1, x2, sy, baseline, do_arch = true):
	var height = rand(-5, -15)
	var platform_height = rand(height / 2 - 1, height / 2 + 1)
	var platform_type = Block.BRICK
	if rand(0, 1) == 0:
		platform_type = Block.PLATFORM
	for x in range(x1, x2 + 1):
		plot(x, sy, Block.BRICK)
		plot(x, sy + height, Block.BRICK)
		for y in range(sy + height + 1, sy):
			plot(x, y, -1)
			plot_wall(x, y, Block.BRICK_WALL)
			if height < -7 and int(y - sy) == int(platform_height):
				plot(x, y, platform_type)
	if do_arch:
		arch(x1, baseline, x2 - x1, sy - baseline)
			
	
func castle(x, y):
	var t1 = tower(x, y)
	
	var start_x = x
	
	for z in range(0, rand(11, 13)):
		var dist = rand(8, 30)
		var t2 = tower(x + dist + t1.x, y)
		var height = rand(-20, max(t1.y, t2.y) + 15)
		if rand(0, 1) == 0:
			hallway(x + t1.x, x + dist + t1.x, height, y, false)
			height = rand(0, height)
			hallway(x + t1.x, x + dist + t1.x, height, y, true)
		else:
			hallway(x + t1.x, x + dist + t1.x, height, y, true)
		x = x + t1.x + dist
		t1 = t2
	pass
	
	for x in range(start_x, x + t1.x):
		for yy in range(y, y + 5):
			plot(x, yy, Block.BRICK)
	
func arch(sx, sy, width, height):
	for x in range(sx, sx + width + 1):
		var t = x - (sx + width * 0.5)
		t = t / (width * 0.5)
		var start = ceil(height * sqrt(1 - t * t))
		for y in range(sy + height, sy + start):
			plot(x, y, Block.BRICK)
		for y in range(sy + start, sy):
			plot(x, y, -1)
			
func chest_underground():
	var sx = rand(-400, 400)
	var sy = rand(50, 400)
	var width = rand(10, 20)
	var height = rand(10, 20)
	
	for x in range(sx, sx + width + 1):
		plot(x, sy, Block.WOOD)
		plot(x, sy + height, Block.WOOD)
	for y in range(sy, sy + height + 1):
		plot(sx, y, Block.WOOD)
		plot(sx + width, y, Block.WOOD)
		
	for x in range(sx + 1, sx + width):
		for y in range(sy + 1, sy + height):
			plot(x, y, -1)
			plot_wall(x, y, Block.ROCK_WALL)
			
	var treasure = []
	if rand(0, 1) == 0:
		treasure.append([Block.JAVELIN, rand(10, 30)])
	if rand(0, 1) == 0:
		treasure.append([Block.ENERGY_PART, rand(3, 10)])
	if rand(0, 2) == 0:
		treasure.append([Block.COPPER_BAR, rand(5, 11)])
	put_chest(sx + int(width / 2), sy + height - 1, treasure)

var physics_are_done = false
func try_create_physics():
	print("--- START PHYSICS CREATION ---")
	var time = OS.get_ticks_msec()
	
	for cell in get_used_cells():
		physics_map.set_cellv(cell, 0)
		
	for bridge in get_used_cells_by_id(9):
		physics_map.set_cellv(bridge, -1)
		platform_map.set_cellv(bridge, 0)
		
	for special in get_used_cells_by_id(Block.SPECIAL):
		physics_map.set_cellv(special, 0) # Chests are transparent
		
	print("--- DONE ---")
	time = OS.get_ticks_msec() - time
	print("took ", time, " ms to do this the hard way")
	
	physics_are_done = true
	
var worldgen_coroutine = null
var worldgen_done = false
	
func _process(delta):
	if not physics_are_done:
		var time = OS.get_ticks_msec()
		
		if worldgen_coroutine == null:
			worldgen_coroutine = generate_the_world()
		
		var deadline = time + 20
		while OS.get_ticks_msec() < deadline:
			if worldgen_coroutine != null:
				worldgen_coroutine = worldgen_coroutine.resume()
				
			if worldgen_done:
				break
				
		if worldgen_done:
			try_create_physics()
			physics_are_done = true
			
			get_tree().paused = false
		
		

func generate_the_world():
	Tree = load("res://tree.tscn")
	physics_map = global.physics_map
	platform_map = global.platform_map
	walls = global.walls
	
	randomize()
	
	var ground_sweep = Vector2(-X_BOUND, 0)
	var allowed = [0, 1, 2, 3]
	while ground_sweep.x < X_BOUND:
		var next = allowed[rand(0, allowed.size() - 1)]
		var result = ground(next, ground_sweep)
		ground_sweep = result[0]
		allowed = result[1]
			
	for i in range(0, 45):
		ground_coal(rand(-X_BOUND, X_BOUND), ROCK)

	yield()

	for i in range(0, 25):
		ground_coal(rand(-X_BOUND, X_BOUND), ROCK, 10)

	yield()

	for i in range(0, 25):
		ground_coal(rand(-X_BOUND, X_BOUND), COAL)
		
	yield()

# Note to self: the shapes created by underground_ore are really interesting
# when not filled in
	for x in range(-X_BOUND, X_BOUND):
		var stop = rand(40, 60)
		var sy = -40
		while get_cell(x, sy) == -1:
			sy += 1
		sy += 3
		if sy < 0:
			sy = 0
		for y in range(sy, stop):
			plot(x, y, DIRT)

		var rate = 200

		for y in range(stop, 200):
			# Decrease density as we descend
			if rand(0, 200) < rate:
				plot(x, y, ROCK)
			rate -= 1
			
		yield()

	for i in range(0, 100):
		var x = rand(-X_BOUND + 20, X_BOUND - 20)
		var y = rand(40, 60)
		var ty = DIRT
		if rand(0, 1) == 0:
			ty = ROCK
		circle(Vector2(x, y), rand(6, 20), ty)
		
		yield()

	for i in range(0, 900):
		var x = rand(-X_BOUND + 20, X_BOUND - 20)
		var y = rand(40, Y_BOUND - 20)

		circle(Vector2(x, y), rand(6, 20), ROCK)
		
		yield()

	for i in range(0, rand(4, 7)):
		var x = rand(-X_BOUND, X_BOUND)
		var y = -40
		while get_cell(x, y) == -1:
			y += 1 
		cave_snake(x, y)
		
		yield()

	for i in range(0, 20):
		var x = rand(-X_BOUND, X_BOUND)
		var y = rand(20, Y_BOUND - 100)
		cave_snake(x, y)
		
		yield()

	for i in range(0, 400):
		var x = rand(-X_BOUND + 20, X_BOUND - 20)
		var y = rand(40, Y_BOUND - 20)
		underground_ore(x, y, DIRT)
		
		yield()

	for i in range(0, 600):
		var x = rand(-X_BOUND + 20, X_BOUND - 20)
		var y = rand(20, Y_BOUND)
		underground_ore(x, y, ROCK)
		
		yield()

	for i in range(0, 400):
		var x = rand(-X_BOUND + 20, X_BOUND - 20)
		var y = rand(20, Y_BOUND)
		underground_ore(x, y, Block.COAL, 3, 7)
		
		yield()

	for i in range(0, 250):
		var x = rand(-X_BOUND + 20, X_BOUND - 20)
		var y = rand(20, Y_BOUND)
		underground_ore(x, y, Block.COPPER_ORE, 3, 7)
		
		yield()
		
	for x in range(-X_BOUND, X_BOUND):
		plot(x, Y_BOUND - 10, 10)
		plot(x, -Y_BOUND + 10, 10)
		
	yield()
	
	for y in range(-Y_BOUND, Y_BOUND):
		plot(-X_BOUND + 10, y, 11)
		plot(X_BOUND - 10, y, 11)
		
	yield()
		
	for i in range(0, 20):
		chest_underground()
		
	yield()
		
	#castle(-375, 0)
	
	var c_spawn_y = -40
	var c_spawn_x = rand(0, 50)
	
	while get_cell(c_spawn_x, c_spawn_y) == -1:
		c_spawn_y += 1
		
	castle(c_spawn_x, c_spawn_y)
	
	yield()
		
	var spawn_y = -40
	var spawn_x = -X_BOUND + 20
	
	while get_cell(spawn_x, spawn_y) == -1 and get_cell(spawn_x + 1, spawn_y) == -1:
		spawn_y += 1
		
	spawn_y -= 10
	set_cell(spawn_x, spawn_y, 7)
	set_cell(spawn_x + 1, spawn_y, 7)
	
	global.spawn_point.position = Vector2(spawn_x, spawn_y) * 4
	global.player.spawn()
	
	global.music.play()
	
	worldgen_done = true
#
#	for i in range(0, 200):
#		var x = rand(-400 + 15, 400 - 15)
#		var y = rand(15, 60)
#		var points = []
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		fill_poly(points, ROCK, true)
#
#	for i in range(0, 50):
#		var x = rand(-400 + 15, 400 - 15)
#		var y = rand(40, 60)
#		var points = []
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		fill_poly(points, ROCK, true)
#
#	for i in range(0, 50):
#		var x = rand(-400 + 15, 400 - 15)
#		var y = rand(40, 60)
#		var points = []
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		fill_poly(points, DIRT, true)
#
#	for i in range(0, 900):
#		var x = rand(-400 + 15, 400 - 15)
#		var y = rand(40, 400 - 15)
#		var points = []
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
#		fill_poly(points, DIRT, true)

	
		
	
			
	##fill_poly([Vector2(-10, 0), Vector2(0, -10), Vector2(10, 0)], DIRT)
