extends Node

var peer := ENetMultiplayerPeer.new()

func _ready() -> void:
	%Game.startServer.connect(startServer)
	%Game.startClient.connect(startClient)

func startServer() -> void:
	peer.create_server(MusGroups.serverInfo["DATA_PORT"])
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(peerConnected)
	MusGroups.sceneReferences["DATA_PEER"] = peer

func startClient() -> void:
	var ip = MusGroups.lobby.get_attribute("SERVER_IP")["value"]
	var port = MusGroups.lobby.get_attribute("DATA_PORT")["value"]
	
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	MusGroups.sceneReferences["DATA_PEER"] = peer

func peerConnected(id: int) -> void:
	print("NO")
	if multiplayer.is_server():
		var e: editors = editors.loadEditors(MusGroups.identifier)
		obtainEditors.rpc_id(id, e.editors)
		
		print("YO")
		sendData(id)

func sendData(id: int) -> void:
	print("BRO")
	#load all the data and put it in an array
	var data: Array
	
	var list = MusGroups.loadListsContext("groups", "server")
	for i in list:
		var g = group.loadGroup(i, MusGroups.identifier)
		data.append(g)
	list = MusGroups.loadListsContext("logic", "server")
	for i in list:
		var l = logic.loadLogic(i, MusGroups.identifier)
		data.append(l)
	
	var m = map.loadMapContext("server")
	data.append(m)
	
	print(data)
	#send all game data :skull:
	for i in data:
		await get_tree().create_timer(0.3).timeout
		receivedResource.rpc_id(id, inst_to_dict(i))

@rpc
func obtainEditors(editor: Array) -> void:
	MusGroups.sceneReferences["editor"].modifyEditor(editor)
	
@rpc("reliable")
func receivedResource(recieved) -> void:
	var resource = dict_to_inst(recieved)
	print(resource)
	if resource is logic:
		resource.save(resource.Instance, MusGroups.identifier)
	else:
		resource.save(MusGroups.identifier)
