@tool
extends Node
signal loadVar

var isDragging: bool = false
var selectedGroup: String

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
		
	if dir.change_dir("user://data/class") != OK:
		print("made class dir")
		dir.make_dir_absolute("user://data/class")
	
	if dir.change_dir("user://data/map") != OK:
		print("made class map")
		dir.make_dir_absolute("user://data/map")
	
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

func save(type: String, data, Name: String) -> void:
	var file
	match type:
		"group":
			file = FileAccess.open("user://data/groups/" + fixFileName(Name) , FileAccess.WRITE)
		"logic":
			file = FileAccess.open("user://data/logic/" + fixFileName(Name) , FileAccess.WRITE)
		_:
			print("ERROR: file save error, proper type not provided.")
	file.store_string(data)
	print("Saved a " + type + " file correctly.")

func loadGroup(instance: String) -> Dictionary:
	if instance == "":
		return {"Error": "faled to generate string"}
	var file = FileAccess.open("user://data/groups/" + fixFileName(instance), FileAccess.READ)
	var contents: Dictionary = JSON.parse_string(file.get_as_text())
	return contents
	
func loadLogic(Name: String) -> Dictionary:
	if Name == "":
		return {"Error": "faled to generate string"}
	var file = FileAccess.open("user://data/logic/" + fixFileName(Name), FileAccess.READ)
	var contents: Dictionary = JSON.parse_string(file.get_as_text())
	return contents

#creates the group JSON file and populates it with the required dictionaries.
func newGroup() -> String:
	var instanceID: String = generateWord("abcdefghijklmnopABCDEFGHIJKLMNOP1234567890", 10)
	var data: Dictionary = {"Name": "", "Location": Vector3(0,0,0), "Logics": [], "Vars": {}}
	var file = FileAccess.open("user://data/groups/" + fixFileName(instanceID), FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	return instanceID
	
func loadSelection() -> void:
	loadVar.emit(selectedGroup)
