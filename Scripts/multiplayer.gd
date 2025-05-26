extends Node

var peer := ENetMultiplayerPeer.new()

#func _ready() -> void:
	#%Game.startServer.connect(startServer)
	#%Game.startClient.connect(startClient)

func startServer() -> void:
	print("starting server...")
	peer.create_server(MusGroups.serverInfo["MP_PORT"])
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(peerConnected)
	peer.peer_disconnected.connect(peerDisconnected)
	MusGroups.sceneReferences["MP_PEER"] = peer

func startClient() -> void:
	var ip = MusGroups.lobby.get_attribute("SERVER_IP")["value"]
	var port = MusGroups.lobby.get_attribute("MP_PORT")["value"]
	
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	MusGroups.sceneReferences["MP_PEER"] = peer

func peerConnected(id: int) -> void:
	pass

func peerDisconnected(id: int) -> void:
	pass

func lobbyUpdated() -> void:
	pass
