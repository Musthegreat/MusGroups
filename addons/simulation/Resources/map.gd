extends Resource
class_name map

@export var data: Dictionary

func append(g) -> void:
	data[g.Instance] = {"POS": g.position_offset, "ID": g.Instance}

func save() -> void:
	ResourceSaver.save(self, "user://"+Singleton.game +"/data/map/map.tres")
	
	Print.apiPrint("Saved map", Singleton.identifier)

static func loadMap() -> Resource:
	if ResourceLoader.exists("user://"+Singleton.game +"/data/map/map.tres"):
		return ResourceLoader.load("user://"+Singleton.game +"/data/map/map.tres") as map
	else:
		return null
