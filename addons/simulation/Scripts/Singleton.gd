extends Node
signal loadSelected

var game: String

var isDragging: bool = false
var selectedGroup: String
var selectedGroupNode: groupVisual
var identifier: String
var logicList: Dictionary

var groupMenu: Control
var maps: Control
var console: RichTextLabel
var inspector: Control

var collection: FirestoreCollection
var data: FirestoreDocument

func newGame(gameName: String) -> void:
	game = gameName
	
	DirAccess.make_dir_absolute("user://" + game)
	
	var dir = DirAccess.open("user://" +game)
	if dir.change_dir("user://"+game +"/data") != OK:
		print("made data dir")
		dir.make_dir_absolute("user://"+game +"/data")
		
	if dir.change_dir("user://"+game +"/data/groups") != OK:
		print("made groups dir")
		dir.make_dir_absolute("user://"+game +"/data/groups")
		
	if dir.change_dir("user://"+game +"/data/logic") != OK:
		print("made logic dir")
		dir.make_dir_absolute("user://"+game +"/data/logic")
		
	if dir.change_dir("user://"+game +"/data/templates") != OK:
		print("made templates dir")
		dir.make_dir_absolute("user://"+game +"/data/templates")
	
	if dir.change_dir("user://"+game +"/data/map") != OK:
		print("made class map")
		dir.make_dir_absolute("user://"+game +"/data/map")

func removeFile(fileName: String, folder: String) -> void:
	DirAccess.remove_absolute("user://"+game +"/data/" + folder + "/"+fileName)

func checkIdentifier(value: String, funcName: String) -> bool:
	if value != Singleton.identifier:
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

func loadLists(type: String) -> PackedStringArray:
	var contents: PackedStringArray = DirAccess.get_files_at("user://"+game +"/data/" + type)
	return contents

func loadSelection() -> void:
	loadSelected.emit(selectedGroup)

func checkLogin() -> bool:
	var auth = Firebase.Auth.auth
	if auth.localid:
		return true
	else:
		return false
