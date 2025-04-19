extends HBoxContainer

@export var delete: Button
@export var option: OptionButton

var list: Array

func _ready() -> void:
	delete.pressed.connect(pressedDelete)

func loadList(Instance: String = "") -> void:
	var dir = Singleton.loadLists("logic")
	for i in dir:
		var l: logic = logic.loadLogic(i, Singleton.identifier)
		option.add_item(l.Name + " - " + l.Instance)
		list.append(l.Instance)
	
	if Instance != "":
		var index = list.find(Instance)
		option.select(index)

func pressedDelete() -> void:
	queue_free()
