extends Resource
class_name map

@export var data: Dictionary

func append(G) -> void:
	data[G.Instance] = {"POS": G.position_offset, "ID": G.Instance}

func save() -> void:
	ResourceSaver.save(self, "user://"+Singleton.game +"/data/map/map.tres")

static func loadMap() -> Resource:
	if ResourceLoader.exists("user://"+Singleton.game +"/data/map/map.tres"):
		return ResourceLoader.load("user://"+Singleton.game +"/data/map/map.tres") as map
	else:
		return null
