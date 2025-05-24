extends Control

func _init() -> void:
	startLobby()

func _ready() -> void:
	MusGroups.sceneReferences["editor"] = self
	
	if MusGroups.context == "client":
		%contextSwitcher.set_current_tab(1) 
	
	%contextSwitcher.tab_changed.connect(switchContext)

func startLobby() -> void:
	#create lobby - move this to settings menu later
	var options = EOS.Lobby.CreateLobbyOptions.new()
	options.bucket_id = "superbob"
	options.max_lobby_members = 10
	options.presence_enabled = false
	options.enable_rtc_room = false
	options.allow_invites = true
	options.local_rtc_options = {flags = EOS.RTC.JoinRoomFlags.EnableDataChannel}
	
	var lobby := await HLobbies.create_lobby_async(options)
	if not lobby:
		print("failed to create lobby.")
		return
	MusGroups.lobby = lobby
	
	print("created lobby!")
	lobby.add_attribute("SERVER_IP", MusGroups.serverInfo["SERVER_IP"])
	lobby.add_attribute("MP_PORT", MusGroups.serverInfo["MP_PORT"])
	lobby.add_attribute("DATA_PORT", MusGroups.serverInfo["DATA_PORT"])
	lobby.add_attribute("EDIT_PORT", MusGroups.serverInfo["EDIT_PORT"])
	lobby.add_attribute("GAME_NAME", MusGroups.game)
	lobby.add_attribute("OWNER_NAME", HAuth.display_name)
	
	var update = await lobby.update_async()
	if not update:
		MusGroups.lobby = null
		get_tree().change_scene_to_packed(preload("res://Scenes/mainMenu.tscn"))

func switchContext(tab: int) -> void:
	if tab == 0:
		MusGroups.context = "server"
	else:
		MusGroups.context = "client"
	get_tree().reload_current_scene()
	
func modifyEditor(editor: Array) -> void:
	for i in editor:
		if i == HAuth.product_user_id:
			return
			
	%TabContainer.tabs_visible = false
	%TabContainer.current_tab = 0

func uploadFiles() -> void:
	pass
