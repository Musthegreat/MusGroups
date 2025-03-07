extends Resource
class_name map

@export var data: Dictionary

func append(node) -> void:
	data[node.Instance] = {"POS": node.global_position, "ID": node.Instance}

func save() -> void:
	print(self.data)
	ResourceSaver.save(self, "user://data/map/map.tres")

static func loadMap() -> Resource:
	if ResourceLoader.exists("user://data/map/map.tres"):
		return ResourceLoader.load("user://data/map/map.tres") as map
	return null
