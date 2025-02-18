extends Node
class_name NetworkManager

signal OnConnectedToServer
signal OnServerDisconnected

@onready var spawned_nodes_container = $MultiplayerSpawner
@onready var player_scene = preload("uid://dib3ya1sug7qy")

var local_username : String
var current_players : Array = []


func start_host(port := 8080) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, 2)
	multiplayer.multiplayer_peer = peer
	
	current_players = []
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	_on_player_connected(multiplayer.get_unique_id())
	_connected_to_server()


func start_client(ip : String, port := 8080) -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
	current_players = []
	
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)


@rpc("any_peer", "call_local", "reliable")
func disconnect_player(player_id : int) -> void:
	multiplayer.multiplayer_peer.disconnect_peer(player_id)


func _on_player_connected(id : int) -> void:
	var player = player_scene.instantiate()
	player.name = str(id)
	spawned_nodes_container.add_child(player, true)


func _on_player_disconnected(id : int) -> void:
	var node = spawned_nodes_container.get_node(str(id))
	
	if current_players.has(node):
		remove_player_from_list(node)
	
	if node:
		node.queue_free()


func _connected_to_server() -> void:
	OnConnectedToServer.emit()


func _connection_failed() -> void:
	pass


func _server_disconnected() -> void:
	OnServerDisconnected.emit()


func add_player_to_list(player) -> void:
	current_players.append(player)


func remove_player_from_list(player) -> void:
	current_players.erase(player)
