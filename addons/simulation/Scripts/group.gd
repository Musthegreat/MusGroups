extends GraphElement
class_name groupVisual

var Instance: String
var Name: String
var Group: group
var graphElement: GraphElement = self

func setInstance(i: String) -> void:
	Instance = i
	Group = group.loadGroup(i)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
