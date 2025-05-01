extends Node
signal client_loadSelected
signal loadSelected

var game: String

var isDragging: bool = false
var identifier: String

var runQeueue: Array
var componentList: Array = [timer]
var componentNamesList: Array = ["timer"]

#region Node and Scene References
var client_selectedGroup: String
var selectedGroup: String

var client_logicList: Dictionary
var logicList: Dictionary

var client_groupMenu: Control
var groupMenu: Control

var client_maps: Control
var maps: Control

var client_console: RichTextLabel
var console: RichTextLabel

var client_inspector: Control
var inspector: Control

var clientSpace: Control
#endregion

func newGame(gameName: String) -> void:
	game = gameName
	
	DirAccess.make_dir_absolute("user://" + game)
	var dir = DirAccess.open("user://" +game)
	
	#client
	if dir.change_dir("user://"+game +"/client/data") != OK:
		print("made client data dir")
		dir.make_dir_absolute("user://"+game +"/client")
		dir.make_dir_absolute("user://"+game +"/client/data")
	
	if dir.change_dir("user://"+game +"/client/data/groups") != OK:
		print("made client groups dir")
		dir.make_dir_absolute("user://"+game +"/client/data/groups")
		
	if dir.change_dir("user://"+game +"/client/data/logic") != OK:
		print("made client logic dir")
		dir.make_dir_absolute("user://"+game +"/client/data/logic")
	
	if dir.change_dir("user://"+game +"/client/data/map") != OK:
		print("made client class map")
		dir.make_dir_absolute("user://"+game +"/client/data/map")
	
	#server
	if dir.change_dir("user://"+game +"/server/data") != OK:
		print("made server data dir")
		dir.make_dir_absolute("user://"+game +"/server")
		dir.make_dir_absolute("user://"+game +"/server/data")
		
	if dir.change_dir("user://"+game +"/server/data/groups") != OK:
		print("made server groups dir")
		dir.make_dir_absolute("user://"+game +"/server/data/groups")
		
	if dir.change_dir("user://"+game +"/server/data/logic") != OK:
		print("made server logic dir")
		dir.make_dir_absolute("user://"+game +"/server/data/logic")
		
	if dir.change_dir("user://"+game +"/server/data/map") != OK:
		print("made server class map")
		dir.make_dir_absolute("user://"+game +"/server/data/map")

func removeFile(fileName: String, folder: String, context: String = "server") -> void:
	DirAccess.remove_absolute("user://"+game +"/"+context+"/data/" + folder + "/"+fileName)

func checkIdentifier(value: String, funcName: String) -> bool:
	if value != identifier:
		Print.printErr(console, "You are not allowed access to function: " + funcName)
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

func loadLists(type: String, context: String = "server") -> PackedStringArray:
	var contents: PackedStringArray = DirAccess.get_files_at("user://"+game +"/"+context+"/data/" + type)
	return contents

func client_loadSelection() -> void:
	client_loadSelected.emit(client_selectedGroup)

func loadSelection() -> void:
	loadSelected.emit(selectedGroup)
