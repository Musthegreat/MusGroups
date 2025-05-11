extends Object
class_name Print

static func apiErr(message: String, Identifier: String) -> void:
	var console = MusGroups.sceneReferences["console"]
	console.newline()
	console.push_bold()
	console.push_color(Color.BROWN)
	console.add_text(message)
	console.pop()	

static func apiPrint(message: String, Identifier: String) -> void:
	var console = MusGroups.sceneReferences["console"]
	console.newline()
	console.add_text(message)
	console.pop()	

static func printErr(console, message) -> void:
	console.newline()
	console.push_bold()
	console.push_color(Color.BROWN)
	console.add_text(message.message)
	console.pop()

static func luaPrint(message) -> void:
	var console = MusGroups.sceneReferences["console"]
	console.newline()
	console.push_mono()
	console.add_text(var_to_str(message))
	console.pop()	
