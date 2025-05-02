extends HBoxContainer
signal openLogic

@export var delete: Button
@export var option: OptionButton

var list: Array

func _ready() -> void:
	delete.pressed.connect(pressedDelete)
	%Open.pressed.connect(func(): openLogic.emit(list[option.get_selected_id()]))

func loadList(Instance: String = "") -> void:
	var dir = MusGroups.loadLists("logic")
	for i in dir:
		var l: logic = logic.loadLogic(i, MusGroups.identifier)
		option.add_item(l.Name + " - " + l.Instance)
		list.append(l.Instance)
	
	if Instance != "":
		var index = list.find(Instance)
		option.select(index)

func pressedDelete() -> void:
	queue_free()
