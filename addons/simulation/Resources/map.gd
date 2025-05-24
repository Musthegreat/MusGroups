extends Resource
class_name map

@export var data: Dictionary

func append(G) -> void:
	data[G.Instance] = {"POS": G.position_offset, "ID": G.Instance}

func save(Identifier: String) -> void:
	ResourceSaver.save(self, "user://games/"+MusGroups.game +"/" +MusGroups.context + "/data/map/map.tres")

static func loadMap() -> Resource:
	if ResourceLoader.exists("user://games/"+MusGroups.game +"/" +MusGroups.context + "/data/map/map.tres"):
		return ResourceLoader.load("user://games/"+MusGroups.game +"/" +MusGroups.context + "/data/map/map.tres") as map
	else:
		return null

static func loadMapContext(context: String) -> Resource:
	if ResourceLoader.exists("user://games/"+MusGroups.game +"/" + context + "/data/map/map.tres"):
		return ResourceLoader.load("user://games/"+MusGroups.game +"/" + context + "/data/map/map.tres") as map
	else:
		return null
