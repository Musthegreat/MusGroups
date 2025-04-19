extends GraphElement
class_name groupVisual

@export var label: Label
@export var instanceLabel: Label
@onready var selection: ColorRect = $ColorRect

var Instance: String
var Name: String
var Group: group

func setInstance(i: String) -> void:
	Group = group.loadGroup(Instance, Singleton.identifier)

func _ready() -> void:
	Singleton.loadSelected.connect(update)
	%Clone.pressed.connect(clone)
	%Delete.pressed.connect(delete)

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

func clone() -> void:
	Groups.clone([Instance])

func delete() -> void:
	queue_free()
	Singleton.maps.allSave(Vector2(0,0),Vector2(0,0))
