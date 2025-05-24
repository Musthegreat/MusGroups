extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	%Game.startServer.connect(startServer)
	%Game.startClient.connect(startClient)

func startServer() -> void:
	pass

func startClient() -> void:
	pass
