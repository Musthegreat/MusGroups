extends Control

var lobby: HLobby

func _ready() -> void:
	%join.pressed.connect(join)

func update(result: HLobby) -> void:
	lobby = result
	
	%gameName.set_text(lobby.get_attribute("GAME_NAME")["value"])
	%playersOnline.set_text("%s/%s" % [lobby.members.size(), lobby.max_members])

func join() -> void:
	MusGroups.context = "client"
	MusGroups.game = lobby.get_attribute("GAME_NAME")["value"]
	
	MusGroups.lobby = await HLobbies.join_async(lobby)
	if not MusGroups.lobby:
		print("failed to create lobby.")
		return
	
	MusGroups.lobby.add_current_member_attribute("USER_NAME", HAuth.display_name)
	await MusGroups.lobby.update_async()
	
	get_tree().change_scene_to_packed(preload("res://Scenes/editor.tscn"))
