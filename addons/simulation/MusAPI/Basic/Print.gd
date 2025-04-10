extends Object
class_name Print

static func apiErr(message: String, Identifier: String) -> void:
	Singleton.console.newline()
	Singleton.console.push_bold()
	Singleton.console.push_color(Color.BROWN)
	Singleton.console.add_text(message)
	Singleton.console.pop()	

static func printErr(console, message) -> void:
	console.newline()
	console.push_bold()
	console.push_color(Color.BROWN)
	console.add_text(message.message)
	console.pop()

static func luaPrint(message) -> void:
	Singleton.console.newline()
	Singleton.console.push_mono()
	Singleton.console.add_text(var_to_str(message))
	Singleton.console.pop()	
