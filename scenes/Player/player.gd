extends Node
class_name Player

@onready var network_manager : NetworkManager = get_node("/root/GameRoom/NetworkManager")

@export var username : String
@export var player_id : int


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())


func _ready() -> void:
	username = network_manager.local_username
	player_id = name.to_int()
	network_manager.add_player_to_list(self)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		network_manager.remove_player_from_list(self)
