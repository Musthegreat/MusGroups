extends Node
signal client_loadSelected
signal loadSelected

var game: String
var context: String
var lua: LuaState = LuaState.new()
var API: LuaTable = lua.create_table()

var isDragging: bool = false
var identifier: String

var runQeueue: Array
var componentList: Array = [group, timer, character]
var componentNamesList: Array = ["group","timer", "character"]

var sceneReferences: Dictionary
var selectedGroup: String

var logicList: Dictionary

var lobby: HLobby
var serverInfo: Dictionary = {"SERVER_IP": "10.0.0.221", "MP_PORT": 2345, "DATA_PORT": 2346, "EDIT_PORT": 2347}

func createDir() -> void:
	DirAccess.make_dir_absolute("user://games")

func newGame(gameName: String) -> void:
	game = gameName
	
	DirAccess.make_dir_absolute("user://games/" + game)
	var dir = DirAccess.open("user://games/" +game)
	
	#client
	if dir.change_dir("user://games/"+game +"/client/data") != OK:
		print("made client data dir")
		dir.make_dir_absolute("user://games/"+game +"/client")
		dir.make_dir_absolute("user://games/"+game +"/client/data")
	
	if dir.change_dir("user://games/"+game +"/client/data/groups") != OK:
		print("made client groups dir")
		dir.make_dir_absolute("user://games/"+game +"/client/data/groups")
		
	if dir.change_dir("user://games/"+game +"/client/data/logic") != OK:
		print("made client logic dir")
		dir.make_dir_absolute("user://games/"+game +"/client/data/logic")
	
	if dir.change_dir("user://games/"+game +"/client/data/map") != OK:
		print("made client class map")
		dir.make_dir_absolute("user://games/"+game +"/client/data/map")
	
	#server
	if dir.change_dir("user://games/"+game +"/server/data") != OK:
		print("made server data dir")
		dir.make_dir_absolute("user://games/"+game +"/server")
		dir.make_dir_absolute("user://games/"+game +"/server/data")
		
	if dir.change_dir("user://games/"+game +"/server/data/groups") != OK:
		print("made server groups dir")
		dir.make_dir_absolute("user://games/"+game +"/server/data/groups")
		
	if dir.change_dir("user://games/"+game +"/server/data/logic") != OK:
		print("made server logic dir")
		dir.make_dir_absolute("user://games/"+game +"/server/data/logic")
		
	if dir.change_dir("user://games/"+game +"/server/data/map") != OK:
		print("made server class map")
		dir.make_dir_absolute("user://games/"+game +"/server/data/map")

func createEnviorment() -> void:
	lua.open_libraries(LuaState.GODOT_VARIANT)
	
	API["This"] = null
	API["Math"] = Math
	API["Groups"] = Groups
	API["pront"] = Print.luaPrint

func removeFile(fileName: String, folder: String) -> void:
	DirAccess.remove_absolute("user://games/"+game +"/"+context+"/data/" + folder + "/"+fileName)

func checkIdentifier(value: String, funcName: String) -> bool:
	if value != identifier:
		Print.printErr(MusGroups.sceneReferences["console"], "You are not allowed access to function: " + funcName)
		return false
	return true
	
func fixFileName(string: String, type: String = ".json") -> String:
	var regex = RegEx.new()
	regex.compile("^\\X[^.]*")
	var result = regex.search(string)
	
	return result.get_string() + type

func generateWord(chars: String, length) -> String:
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func loadLists(type: String) -> PackedStringArray:
	var contents: PackedStringArray = DirAccess.get_files_at("user://games/"+game +"/"+context+"/data/" + type)
	return contents

func loadListsContext(type: String, context: String) -> PackedStringArray:
	var contents: PackedStringArray = DirAccess.get_files_at("user://games/"+game +"/"+context+"/data/" + type)
	return contents

func loadGames() -> PackedStringArray:
	var contents: PackedStringArray = DirAccess.get_directories_at("user://games")
	return contents

func loadSelection() -> void:
	loadSelected.emit(selectedGroup)

func setupLogging() -> void:
	HPlatform.log_msg.connect(MusGroups._on_eos_log_msg)

# This method is called when we get a log message from EOS SDK
func _on_eos_log_msg(msg: EOS.Logging.LogMessage) -> void:
	print("SDK %s | %s" % [msg.category, msg.message])
