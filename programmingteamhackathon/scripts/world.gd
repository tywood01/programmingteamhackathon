extends Node3D

@export var player_scene : PackedScene
const Player = preload("res://scenes/Player.tscn")

const PORT = 9999
var peer = ENetMultiplayerPeer.new()


func _on_host_pressed():
	$CanvasLayer.hide()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())

func _on_join_pressed():
	$CanvasLayer.hide()
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
