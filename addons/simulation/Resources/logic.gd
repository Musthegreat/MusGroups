extends Resource
class_name logic

@export var unsplitCode: String

func save(name, identifier) -> void:
	if Singleton.checkIdentifier(identifier, "logic:save") != true:
		return
	
	ResourceSaver.save(self, "user://data/logic/" + Singleton.fixFileName(name, ".tres"))

static func loadLogic(name, identifier) -> Resource:
	if Singleton.checkIdentifier(identifier, "logic:loadLogic") != true:
		return
	
	if ResourceLoader.exists("user://data/logic/" + name):
		return ResourceLoader.load("user://data/logic/" + name) as logic
	else:
		return null
