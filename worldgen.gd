extends TileMap

var GRASS = 0
var DIRT = 1
var ROCK = 2

var physics_map

func snap_number(num, count):
		var res = int(num) % count
		if res < 0: res += count
		return res

func handle(x, y, id):
	return Vector2(snap_number(x, 64), snap_number(y, 64))

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
				
func grass(x, y):
	for a in range(0, rand(3, 4)):
		plot(x, y + a, GRASS)
				
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

func _ready():
	physics_map = get_node("/root/root/physics_map")
	
	randomize()
#
#	for x in range(-400, 400):
#		var stop = rand(40, 60)
#		for y in range(0, stop):
#			plot(x, y, DIRT)
#		for y in range(stop, 400):
#			plot(x, y, ROCK)
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

	
		
	var ground_sweep = Vector2(-400, 0)
	var allowed = [0, 1, 2, 3]
	while ground_sweep.x < 400:
		var next = allowed[rand(0, allowed.size() - 1)]
		var result = ground(next, ground_sweep)
		ground_sweep = result[0]
		allowed = result[1]
			
	##fill_poly([Vector2(-10, 0), Vector2(0, -10), Vector2(10, 0)], DIRT)

	
