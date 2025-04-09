extends Control

@export var newLogic: Button
@export var saveLogic: Button
@export var logicHolder: VBoxContainer
@export var logicContainer: PackedScene
@export var nodeName: LineEdit
@export var confirm: Button

func _ready() -> void:
	newLogic.pressed.connect(logicAdd)
	saveLogic.pressed.connect(logicSelected)
	Singleton.loadSelected.connect(loadSelected)
	confirm.pressed.connect(changeName)

func changeName() -> void:
	var g = group.loadGroup(Singleton.selectedGroup, Singleton.identifier)
	g.Name = nodeName.get_text()
	g.save(Singleton.identifier)
	Singleton.loadSelection()

func logicAdd(index: int = 0) -> void:
	var addLogic: = logicContainer.instantiate()
	logicHolder.add_child(addLogic)
	addLogic.option.item_selected.connect(logicSelected)
	
	var dir: PackedStringArray = Singleton.loadLists("logic")
	for i in dir.size():
		addLogic.option.add_item(dir[i])
	addLogic.option.select(index)

func loadSelected(selectedGroup) -> void:
	for child in logicHolder.get_children():
		if child is HBoxContainer:
			child.queue_free()
	
	var g = group.loadGroup(selectedGroup, Singleton.identifier)
	nodeName.set_text(g.Name)
	var l: PackedStringArray = Singleton.loadLists("logic")
	for i in g.Logics:
		logicAdd(l.find(i))

func logicSelected() -> void:
	print("selected")
	var g = group.loadGroup(Singleton.selectedGroup, Singleton.identifier)
	g.Logics.clear()
	for child in logicHolder.get_children():
		if child is HBoxContainer:
			print(child.option.get_item_text(child.option.selected))
			g.Logics.append(child.option.get_item_text(child.option.selected))
	g.save(Singleton.identifier)
