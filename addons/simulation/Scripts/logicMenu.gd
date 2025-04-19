extends Control

@export var conditionContainer: VBoxContainer
@export var logicList: ItemList
@export var saveButton: Button
@export var Name: LineEdit

@export var condition: CodeEdit

var secretLogicList: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Singleton.newGame("bust city")
	logicList.item_selected.connect(loadLogic)
	saveButton.pressed.connect(save)
	
	%createLogicButton.pressed.connect(createLogic)
	%Delete.pressed.connect(deleteLogic)
	
	refreshList()

func refreshList(selected: int = 0) -> void:
	logicList.clear()
	
	var dir = Singleton.loadLists("logic")
	for i in dir:
		var l: logic = logic.loadLogic(Singleton.fixFileName(i, ""), Singleton.identifier)
		var index: int = logicList.add_item(l.Name)
		logicList.set_item_metadata(index, l.Instance)
	
	Name.set_text(logicList.get_item_text(selected))
	if Singleton.logicList.size() > 0:
		loadLogic(selected)

func loadLogic(index: int) -> void:
	Name.set_editable(true)
	logicList.select(index)
	
	var selected = logicList.get_item_text(index)
	
	var l: logic = logic.loadLogic(logicList.get_item_metadata(index), Singleton.identifier)
	if l != null:
		condition.set_text(l.unsplitCode)
		Name.set_text(l.Name)

func createLogic() -> void:
	Name.set_editable(true)
	
	var l: logic = logic.new()
	l.Name = "logicName"
	l.Instance = Singleton.generateWord("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890", 10)
	l.save(l.Instance, Singleton.identifier)
	Singleton.logicList[l.Instance] = {"Name": l.Name, "Instance": l.Instance}
	Name.set_text("logicName")
	condition.set_text("")
	
	var index: int = logicList.add_item("logicName")
	logicList.set_item_metadata(index, l.Instance)
	logicList.select(index)

func save() -> void:
	if logicList.is_anything_selected():
		var selected = logicList.get_selected_items()[0]
		var l: logic = logic.loadLogic(logicList.get_item_metadata(selected), Singleton.identifier)
		print(logicList.get_item_metadata(selected))
		if l != null:
			print(logicList.get_item_metadata(selected))
			l.unsplitCode = condition.get_text()
			l.Name = Name.get_text()
			l.save(logicList.get_item_metadata(selected), Singleton.identifier)
			Singleton.logicList[l.Instance] = {"Name": l.Name, "Instance": l.Instance}
		refreshList(logicList.get_selected_items()[0])

func deleteLogic() -> void:
	if logicList.is_anything_selected():
		var selected: int = logicList.get_selected_items()[0]
		var Instance: String = logicList.get_item_metadata(selected)
		Singleton.removeFile(Singleton.fixFileName(Instance, ".tres"), "logic")
		refreshList()
		
		var dir = Singleton.loadLists("groups")
		for i in dir:
			var g: group = group.loadGroup(i, Singleton.identifier)
			g.Logics.remove_at(g.Logics.find(Instance))
			g.save(Singleton.identifier)
