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
				

func _ready():
	physics_map = get_node("/root/root/physics_map")
	
	for x in range(-400, 400):
		var stop = rand(40, 60)
		for y in range(0, stop):
			plot(x, y, DIRT)
		for y in range(stop, 400):
			plot(x, y, ROCK)
			
	for i in range(0, 200):
		var x = rand(-400 + 15, 400 - 15)
		var y = rand(15, 60)
		var points = []
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		fill_poly(points, ROCK, true)
		
	for i in range(0, 50):
		var x = rand(-400 + 15, 400 - 15)
		var y = rand(40, 60)
		var points = []
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		fill_poly(points, ROCK, true)
		
	for i in range(0, 50):
		var x = rand(-400 + 15, 400 - 15)
		var y = rand(40, 60)
		var points = []
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		fill_poly(points, DIRT, true)
			
	for i in range(0, 900):
		var x = rand(-400 + 15, 400 - 15)
		var y = rand(40, 400 - 15)
		var points = []
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		points.append(Vector2(x + rand(-15, 15), y + rand(-15, 15)))
		fill_poly(points, DIRT, true)
			
	##fill_poly([Vector2(-10, 0), Vector2(0, -10), Vector2(10, 0)], DIRT)

	
