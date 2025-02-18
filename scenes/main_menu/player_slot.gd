extends Panel
class_name PlayerSlot

@onready var player_name: Label = $PlayerName
@onready var button: Button = $Button

var current_player : Player


func update_slot_ui(player : Player) -> void:
	current_player = player
	player_name.text = player.username
	
	var is_local = player.is_multiplayer_authority()
	
	if not multiplayer.is_server():
		button.hide()
	else:
		button.visible = not is_local


func _on_button_pressed() -> void:
	if not multiplayer.is_server():
		return
	
	get_node("/root/GameRoom/NetworkManager").disconnect_player.rpc(current_player.player_id)
