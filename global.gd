extends Node

var permadeath = false

# Global variables. This is refactoring so that we
# can use a scaled down viewport, to try to see if
# that speeds up the browser version.

var root: Node2D = null # root/root
var physics_map: TileMap = null # root/root/physics_map
var platform_map: TileMap = null # root/root/platform_map
var tiles: TileMap = null
var walls: TileMap = null # root/root/walls
var spawn_point: Node2D = null # root/root/spawn_point
var player: KinematicBody2D = null # root/root/player
var music: AudioStreamPlayer = null # root/root/music
var light_viewport: Viewport = null # root/root/light_viewport
var cursor = null
