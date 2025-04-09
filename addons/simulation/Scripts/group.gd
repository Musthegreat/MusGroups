extends GraphElement
class_name groupVisual

@export var label: Label

var Instance: String
var Name: String
var Group: group
var graphElement: GraphElement = self

func setInstance(i: String) -> void:
	Group = group.loadGroup(Instance, Singleton.identifier)

func _ready() -> void:
	Singleton.loadSelected.connect(update)

func update(I) -> void:
	if I == Instance:
		var g = group.loadGroup(I, Singleton.identifier)
		setName(g.Name)

func setName(name: String) -> void:
	Name = name
	label.set_text(name)
