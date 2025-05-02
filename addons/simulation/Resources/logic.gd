extends Resource
class_name logic

@export var unsplitCode: String
@export var Instance: String
@export var Name: String

func save(Instance, identifier) -> void:
	if MusGroups.checkIdentifier(identifier, "logic:save()") != true:
		return
	
	ResourceSaver.save(self, "user://"+MusGroups.game +"/server/data/logic/" + MusGroups.fixFileName(Instance, ".tres"))

static func loadLogic(Instance, identifier) -> Resource:
	if MusGroups.checkIdentifier(identifier, "logic:loadLogic()") != true:
		return
	
	if ResourceLoader.exists("user://"+MusGroups.game +"/server/data/logic/" + MusGroups.fixFileName(Instance, ".tres")):
		return ResourceLoader.load("user://"+MusGroups.game +"/server/data/logic/" + MusGroups.fixFileName(Instance, ".tres")) as logic
	else:
		return null
