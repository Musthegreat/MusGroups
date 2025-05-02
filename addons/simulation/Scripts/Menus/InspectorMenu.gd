extends Control
signal openLogic

@export var newLogic: Button
@export var saveLogic: Button
@export var logicHolder: VBoxContainer
@export var logicContainer: PackedScene
@export var nodeName: LineEdit
@export var confirm: Button

func _ready() -> void:
	newLogic.pressed.connect(logicAdd)
	saveLogic.pressed.connect(logicSave)
	MusGroups.loadSelected.connect(logicLoad)
	confirm.pressed.connect(changeName)
	$BoxContainer/clone.pressed.connect(clone)
	$BoxContainer/remove.pressed.connect(remove)
	
	MusGroups.inspector = self

func clone() -> void:
	var g: group = group.loadGroup(MusGroups.selectedGroup, MusGroups.identifier)
	g.clone()

func remove() -> void:
	Groups.removeByID(MusGroups.selectedGroup)

func changeName() -> void:
	var g = group.loadGroup(MusGroups.selectedGroup, MusGroups.identifier)
	g.Name = nodeName.get_text()
	g.save(MusGroups.identifier)
	MusGroups.loadSelection()
	
	Print.apiPrint("changed name of group", MusGroups.identifier)

func logicLoad(selectedGroup) -> void:
	for child in %componentMenu.get_children():
		child.queue_free()
	
	for child in logicHolder.get_children():
		if child is HBoxContainer:
			child.queue_free()
	
	var g = group.loadGroup(selectedGroup, MusGroups.identifier)
	nodeName.set_text(g.Name)
	for i in g.Menu:
		var menu = i.instantiate()
		%componentMenu.add_child(menu)
		
	for i in g.Logics:
		logicAdd(i)

func logicAdd(Instance: String = "") -> void:
	var newLogicContainer: = logicContainer.instantiate()
	logicHolder.add_child(newLogicContainer)
	newLogicContainer.option.item_selected.connect(logicSave)
	newLogicContainer.openLogic.connect(func(Instance): openLogic.emit(Instance))
	newLogicContainer.loadList(Instance)

func logicSave() -> void:
	var g = group.loadGroup(MusGroups.selectedGroup, MusGroups.identifier)
	g.Logics.clear()
	for child in logicHolder.get_children():
		if child is HBoxContainer:
			g.Logics.append(child.list[child.option.selected])
			
	g.save(MusGroups.identifier)
	Print.apiPrint("Saved logic", MusGroups.identifier)
