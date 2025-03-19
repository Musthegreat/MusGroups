extends Resource
class_name logic

@export var unsplitCode: String
@export var splitCode: PackedStringArray

func save(name) -> void:
	splitCode = cleanupCode()
	ResourceSaver.save(self, "user://data/logic/" + Singleton.fixFileName(name, ".tres"))

func cleanupCode() -> PackedStringArray:
	var regex: RegEx = RegEx.new()
	regex.compile("\\Q\n\\E")
	var r = regex.sub(unsplitCode," ", true)
	var result = r.split(" ")
	print(result)
	return result

static func loadLogic(name) -> Resource:
	if ResourceLoader.exists("user://data/logic/" + name):
		return ResourceLoader.load("user://data/logic/" + name) as logic
	else:
		return null
