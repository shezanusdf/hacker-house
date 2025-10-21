extends Control

@export var adress = "127.0.0.1"
@export var port = 7860
var peer 
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	
func _process(_delta: float) -> void:
	pass
	
#this gets called on the server and clients
func peer_connected(id):
	print("Player Connected" + id)

#this gets called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected" + id)

#this gets fired only from clients
func connected_to_server():
	print("Connected to Server!")

#this gets fired only from clients
func connection_failed():
	print("connection failed!")

func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 3)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players...")


func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(adress, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_game_button_down() -> void:
	pass # Replace with function body.
