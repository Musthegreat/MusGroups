extends Resource
class_name group

@export var Name: String
@export var Instance: String
@export var Connections: Array
@export var Variables: Dictionary
@export var Logics: Array

func save(identifier) -> void:
	ResourceSaver.save(self, "user://data/groups/" + Singleton.fixFileName(Instance, ".tres"))

static func loadGroup(Instance: String, identifier: String) -> Resource:
	if Singleton.checkIdentifier(identifier, "loadGroup") != true:
		Print.printErr(Singleton.console, "Failed to load group with ID of " + Instance)
		return
	
	if ResourceLoader.exists("user://data/groups/" + Instance + ".tres"):
		return ResourceLoader.load("user://data/groups/" + Instance + ".tres") as group
	else:
		return null

#region MusAPI
static func getGroup(Instance: String) -> group:
	return group.loadGroup(Instance, Singleton.identifier)

func getVar(varName: String):
	return Variables[varName]["Data"]

func getVarType(varName: String):
	return Variables[varName]["Type"]
#endregion
