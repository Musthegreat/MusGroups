extends GraphElement
class_name groupVisual

@export var label: Label
@export var instanceLabel: Label
@onready var selection: ColorRect = $ColorRect

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
		selection.show()
		
		var g = group.loadGroup(I, Singleton.identifier)
		if g == null:
			return
		
		setName(g.Name)
		instanceLabel.set_text(I)
	else:
		selection.hide()
		
func setName(name: String) -> void:
	Name = name
	label.set_text(name)
