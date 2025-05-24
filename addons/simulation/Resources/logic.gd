extends Resource
class_name logic

@export var unsplitCode: String
@export var Instance: String
@export var Name: String

func save(Instance, identifier) -> void:
	if MusGroups.checkIdentifier(identifier, "logic:save()") != true:
		return
	
	ResourceSaver.save(self, "user://games/"+MusGroups.game +"/" +MusGroups.context + "/data/logic/" + MusGroups.fixFileName(Instance, ".tres"))

static func loadLogic(Instance, identifier) -> Resource:
	if MusGroups.checkIdentifier(identifier, "logic:loadLogic()") != true:
		return
	
	if ResourceLoader.exists("user://games/"+MusGroups.game +"/" +MusGroups.context + "/data/logic/" + MusGroups.fixFileName(Instance, ".tres")):
		return ResourceLoader.load("user://games/"+MusGroups.game +"/" +MusGroups.context + "/data/logic/" + MusGroups.fixFileName(Instance, ".tres")) as logic
	else:
		return null
