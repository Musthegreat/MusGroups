@tool
extends Control

@export var newLogic: Button
@export var logicHolder: VBoxContainer
var logic: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	newLogic.pressed.connect(addLogic)

func addLogic() -> void:
	logic = OptionButton.new()
	logicHolder.add_child(logic)
	logic.set_text("Choose Logic")
	
	var dir: PackedStringArray = Singleton.loadLists("logic")
	for i in dir.size():
		logic.add_item(dir[i])
