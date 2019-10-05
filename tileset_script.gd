tool
extends TileSet

class Tiler:
	var autotile_id
	var bitmask
	var tilemap
	var tile_location

	var result = Vector2(0, 0)

	func snap_number(num, count):
		var res = int(num) % count
		if res < 0: res += count
		return res

	func _init(autotile_id_, bitmask_, tilemap_, tile_location_):
		autotile_id = autotile_id_
		bitmask = bitmask_
		tilemap = tilemap_
		tile_location = tile_location_

	func grasslike(id, xcount, ycount):
		if id != autotile_id:
			return
		var x = snap_number(tile_location.x, xcount)
		var y = snap_number(tile_location.y, ycount)
		result = Vector2(x, y)

	func detaillike_(id, xcount, has_central):
		var tilemap_: TileMap = tilemap
		var behind = (tilemap_.get_cell(tile_location.x - 1, tile_location.y) == -1)
		var ahead = (tilemap_.get_cell(tile_location.x + 1, tile_location.y) == -1)
		if behind:
			if ahead:
				if has_central:
					return Vector2(2 + xcount, 0)
				else:
					return Vector2(1, 0)
			return Vector2(0, 0)
		if ahead:
			return Vector2(1 + xcount, 0)
		var x = snap_number(tile_location.x, xcount)
		#var y = snap_number(tile_location.y, 4)
		return Vector2(1 + x, 0)

	func detaillike(id, xcount, has_central):
		if id != autotile_id:
			return
		result = detaillike_(id, xcount, has_central)

func _forward_subtile_selection(autotile_id, bitmask, tilemap, tile_location):
	var tiler = Tiler.new(autotile_id, bitmask, tilemap, tile_location)

	tiler.grasslike(0, 64, 64)
	tiler.grasslike(1, 64, 64)
	tiler.grasslike(2, 64, 64)

	return tiler.result