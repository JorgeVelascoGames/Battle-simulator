extends Node
class_name SceneManager

@onready var canvas_layer: CanvasLayer = $CanvasLayer
const BATTLE_ROOM = preload("res://scenes/battle_room/battle_room.tscn")
const MAIN_MENU = preload("res://scenes/main_menu/main_menu.tscn")

var menu_scene
var game_scene



func _ready() -> void:
	menu_scene = MAIN_MENU.instantiate()
	game_scene = BATTLE_ROOM.instantiate()
	canvas_layer.add_child(menu_scene)


@rpc("authority", "call_local", "reliable")
func load_menu_scene() -> void:
	canvas_layer.remove_child(game_scene)
	canvas_layer.add_child(menu_scene)


@rpc("authority", "call_local", "reliable")
func load_game_scene() -> void:
	canvas_layer.remove_child(menu_scene)
	canvas_layer.add_child(game_scene)
	game_scene.set_up_battle_room()
