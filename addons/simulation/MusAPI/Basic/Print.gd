extends Object
class_name Print

static func apiErr(message: String, Identifier: String) -> void:
	MusGroups.console.newline()
	MusGroups.console.push_bold()
	MusGroups.console.push_color(Color.BROWN)
	MusGroups.console.add_text(message)
	MusGroups.console.pop()	

static func apiPrint(message: String, Identifier: String) -> void:
	MusGroups.console.newline()
	MusGroups.console.add_text(message)
	MusGroups.console.pop()	

static func printErr(console, message) -> void:
	console.newline()
	console.push_bold()
	console.push_color(Color.BROWN)
	console.add_text(message.message)
	console.pop()

static func luaPrint(message) -> void:
	MusGroups.console.newline()
	MusGroups.console.push_mono()
	MusGroups.console.add_text(var_to_str(message))
	MusGroups.console.pop()	
