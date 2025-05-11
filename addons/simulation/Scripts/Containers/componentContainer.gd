extends Control

var type: GDScript
var typeName: String = "Name not provided"

func _ready() -> void:
	%Add.pressed.connect(addComponent)

func setName() -> void:
	%Name.set_text("   " + typeName)

func addComponent() -> void:
	MusGroups.sceneReferences["map"].componentAdd(type, typeName)
