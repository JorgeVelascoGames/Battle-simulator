extends Control
class_name MainMenu

@onready var network_manager : NetworkManager = get_node("/root/GameRoom/NetworkManager")
@onready var username_input: LineEdit = $LogScreen/VBoxContainer/MarginContainer3/UsernameInput
@onready var log_screen: Control = $LogScreen
@onready var lobby: Control = $Lobby

var ip := "localhost"
var port := 9999


func _ready() -> void:
	network_manager.OnConnectedToServer.connect(_open_lobby)
	network_manager.OnServerDisconnected.connect(_open_main_menu)


func _open_main_menu() -> void:
	log_screen.show()
	lobby.hide()


func _open_lobby() -> void:
	log_screen.hide()
	lobby.show()


func _on_create_lobby_pressed() -> void:
	network_manager.local_username = username_input.text
	network_manager.start_host(int(port))


func _on_join_lobby_pressed() -> void:
	network_manager.local_username = username_input.text
	network_manager.start_client(ip, int(port))
