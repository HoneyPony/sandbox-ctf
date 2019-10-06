extends TileMap

var GRASS = 0
var DIRT = 1
var ROCK = 2
var COAL = 4

var physics_map

var Tree

var Block = preload("res://block.gd")

func snap_number(num, count):
	var res = int(num) % count
	if res < 0: res += count
	return res

func handle(x, y, id):
	var n = Block.tiles(id)
	return Vector2(snap_number(x, n), snap_number(y, n))

func plot(x, y, id):
	set_cell(x, y, id, false, false, false, handle(x, y, id))
	
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
				
var last_tree = -400
var last_run = -800
var tree_run = 0

func finish_tree(x, y):
	var t = Tree.instance()
	t.position = Vector2(x * 4, (y + 1) * 4)
	get_node("/root/root").call_deferred("add_child", t)

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
	
	if s.x + width > 400:
		width = 400 - s.x
	
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
		
	if s.x + width > 400:
		width = 400 - s.x
		
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
		
	if s.x + width > 400:
		width = 400 - s.x
		
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
	
	if s.x + width > 400:
		width = 400 - s.x
	
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
	
	if s.x + width > 400:
		width = 400 - s.x
	
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

func _ready():
	Tree = load("res://tree.tscn")
	physics_map = get_node("/root/root/physics_map")
	
	randomize()
	
	var ground_sweep = Vector2(-400, 0)
	var allowed = [0, 1, 2, 3]
	while ground_sweep.x < 400:
		var next = allowed[rand(0, allowed.size() - 1)]
		var result = ground(next, ground_sweep)
		ground_sweep = result[0]
		allowed = result[1]
			
	for i in range(0, 45):
		ground_coal(rand(-400, 400), ROCK)

	for i in range(0, 25):
		ground_coal(rand(-400, 400), ROCK, 10)

	for i in range(0, 25):
		ground_coal(rand(-400, 400), COAL)

# Note to self: the shapes created by underground_ore are really interesting
# when not filled in
	for x in range(-400, 400):
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
		
	for i in range(0, 100):
		var x = rand(-400 + 20, 400 - 20)
		var y = rand(40, 60)
		var ty = DIRT
		if rand(0, 1) == 0:
			ty = ROCK
		circle(Vector2(x, y), rand(6, 20), ty)
		
	for i in range(0, 900):
		var x = rand(-400 + 20, 400 - 20)
		var y = rand(40, 400 - 20)
		
		circle(Vector2(x, y), rand(6, 20), ROCK)
		
	for i in range(0, rand(4, 7)):
		var x = rand(-400, 400)
		var y = -40
		while get_cell(x, y) == -1:
			y += 1 
		cave_snake(x, y)
		
	for i in range(0, 20):
		var x = rand(-400, 400)
		var y = rand(20, 300)
		cave_snake(x, y)
		
	for i in range(0, 400):
		var x = rand(-400 + 20, 400 - 20)
		var y = rand(40, 400 - 20)
		underground_ore(x, y, DIRT)
		
	for i in range(0, 600):
		var x = rand(-400 + 20, 400 - 20)
		var y = rand(20, 400)
		underground_ore(x, y, ROCK)
		
	for i in range(0, 400):
		var x = rand(-400 + 20, 400 - 20)
		var y = rand(20, 400)
		underground_ore(x, y, Block.COAL, 3, 7)
		
	for i in range(0, 250):
		var x = rand(-400 + 20, 400 - 20)
		var y = rand(20, 400)
		underground_ore(x, y, Block.COPPER_ORE, 3, 7)
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

	
