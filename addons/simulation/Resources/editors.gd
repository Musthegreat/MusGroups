extends Resource
class_name editors

@export var editors: Array

func save(identifier) -> void:
	if MusGroups.checkIdentifier(identifier, "logic:save()") != true:
		return
	
	ResourceSaver.save(self, "user://games/"+MusGroups.game +"/" + MusGroups.fixFileName("Editors", ".tres"))

static func loadEditors(identifier) -> Resource:
	if MusGroups.checkIdentifier(identifier, "editors:loadEditors()") != true:
		return
	
	if ResourceLoader.exists("user://games/"+MusGroups.game +"/" + MusGroups.fixFileName("Editors", ".tres")):
		return ResourceLoader.load("user://games/"+MusGroups.game +"/" + MusGroups.fixFileName("Editors", ".tres")) as editors
	else:
		return null
