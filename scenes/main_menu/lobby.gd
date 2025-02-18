extends Control

@onready var network_manager : NetworkManager = get_node("/root/GameRoom/NetworkManager")
@onready var player_slot_list: VBoxContainer = $PlayerSlotList
@onready var start_game_button: Button = $VBoxContainer/StartGame
@onready var scene_manager : SceneManager = get_node("/root/GameRoom")

var player_slots : Array[PlayerSlot] = []


func _ready() -> void:
	for slot in player_slot_list.get_children():
		player_slots.append(slot)
	update_ui()


func update_ui() -> void:
	if not visible:
		return
	
	start_game_button.visible = multiplayer.is_server()
	
	var player_count = len(network_manager.current_players)
	
	for i in len(player_slots):
		var slot = player_slots[i]
		
		if i < player_count:
			slot.show()
			slot.update_slot_ui(network_manager.current_players[i])
		else:
			slot.hide()


func _on_start_game_pressed() -> void:
	scene_manager.load_game_scene.rpc()


func _on_leave_lobby_pressed() -> void:
	if multiplayer.is_server():
		$".."._open_main_menu()
	multiplayer.multiplayer_peer.close()
