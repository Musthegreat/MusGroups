extends Node
signal loadSelected

var isDragging: bool = false
var selectedGroup: String
var identifier: String

#things the api has to have access to
var maps
var console: RichTextLabel

func firstLoad() -> void:
	var dir = DirAccess.open("user://")
	if dir.change_dir("user://data") != OK:
		print("made data dir")
		dir.make_dir_absolute("user://data")
		
	if dir.change_dir("user://data/groups") != OK:
		print("made groups dir")
		dir.make_dir_absolute("user://data/groups")
		
	if dir.change_dir("user://data/logic") != OK:
		print("made logic dir")
		dir.make_dir_absolute("user://data/logic")
		
	if dir.change_dir("user://data/templates") != OK:
		print("made templates dir")
		dir.make_dir_absolute("user://data/templates")
	
	if dir.change_dir("user://data/map") != OK:
		print("made class map")
		dir.make_dir_absolute("user://data/map")
	
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
	var contents: PackedStringArray = DirAccess.get_files_at("user://data/" + type)
	return contents

func loadSelection() -> void:
	loadSelected.emit(selectedGroup)
