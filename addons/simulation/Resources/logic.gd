extends Resource
class_name logic

@export var unsplitCode: String
@export var Instance: String
@export var Name: String

func save(Instance, identifier) -> void:
	if Singleton.checkIdentifier(identifier, "logic:save()") != true:
		return
	
	ResourceSaver.save(self, "user://"+Singleton.game +"/data/logic/" + Singleton.fixFileName(Instance, ".tres"))

static func loadLogic(Instance, identifier) -> Resource:
	if Singleton.checkIdentifier(identifier, "logic:loadLogic()") != true:
		return
	
	if ResourceLoader.exists("user://"+Singleton.game +"/data/logic/" + Singleton.fixFileName(Instance, ".tres")):
		return ResourceLoader.load("user://"+Singleton.game +"/data/logic/" + Singleton.fixFileName(Instance, ".tres")) as logic
	else:
		return null
