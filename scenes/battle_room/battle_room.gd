extends Node2D

@onready var network_manager : NetworkManager = get_node("/root/GameRoom/NetworkManager")
@onready var log: Label = $CanvasLayer/Log

var local_player : Player
var enemy : Player


func set_up_battle_room() -> void:
	for player in network_manager.current_players:
		if player.player_id == multiplayer.get_unique_id():
			local_player = player
		else:
			enemy = player
	$CanvasLayer/Panel/User.text = local_player.username
	$CanvasLayer/Panel/Enemy.text = enemy.username


@rpc("any_peer", "call_local", "reliable")
func attack(attacker : String) -> void:
	log.text += "\n" + attacker + " attacks!"


func _on_attack_test_pressed() -> void:
	attack.rpc(local_player.username)
