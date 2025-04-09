extends Resource
class_name map

@export var data: Dictionary

func append(g) -> void:
	data[g.instance] = {"POS": g.position_offset, "ID": g.instance}

func save() -> void:
	ResourceSaver.save(self, "user://data/map/map.tres")

static func loadMap() -> Resource:
	if ResourceLoader.exists("user://data/map/map.tres"):
		return ResourceLoader.load("user://data/map/map.tres") as map
	else:
		return null
