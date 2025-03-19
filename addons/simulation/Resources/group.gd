extends Resource
class_name group

@export var Name: String
@export var Instance: String
@export var Connections: Array
@export var Variables: Dictionary
@export var Logics: Array

func save() -> void:
	ResourceSaver.save(self, "user://data/groups/" + Singleton.fixFileName(Instance, ".tres"))

static func loadGroup(I) -> Resource:
	if ResourceLoader.exists("user://data/groups/" + I + ".tres"):
		return ResourceLoader.load("user://data/groups/" + I + ".tres") as group
	else:
		return null
