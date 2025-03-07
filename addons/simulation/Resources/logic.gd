extends Resource
class_name logic

@export var unsplitCode: String
@export var splitCode: PackedStringArray

func save(name) -> void:
	splitCode = unsplitCode.split(" ")
	print(splitCode)
	ResourceSaver.save(self, "user://data/logic/" + Singleton.fixFileName(name, ".tres"))

static func loadLogic(name) -> Resource:
	if ResourceLoader.exists("user://data/logic/" + name):
		return ResourceLoader.load("user://data/logic/" + name) as logic
	else:
		return null
