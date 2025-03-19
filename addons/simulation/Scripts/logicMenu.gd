extends Control

@export var conditionContainer: VBoxContainer
@export var logicList: OptionButton
@export var saveButton: Button
@export var Name: LineEdit

@onready var condition: CodeEdit = $VBoxContainer/ScrollContainer/conditionContainer/condition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Singleton.firstLoad()
	logicList.item_selected.connect(loadLogic)
	saveButton.pressed.connect(save)
	
	refreshList()

func refreshList() -> void:
	logicList.clear()
	
	var dir: PackedStringArray = Singleton.loadLists("logic")
	for i in dir.size():
		logicList.add_item(dir[i]) 
		
	Name.set_text(logicList.get_item_text(0))
	loadLogic(0)

func loadLogic(index) -> void:
	var code: logic = logic.loadLogic(logicList.get_item_text(index))
	if code == null:
		Name.set_text(logicList.get_item_text(index))
		print("whoops")
	else:
		code.loadLogic(logicList.get_item_text(index))
		condition.set_text(code.unsplitCode)
		Name.set_text(logicList.get_item_text(index))

func save() -> void:
	var code: logic = logic.loadLogic(logicList.get_item_text(logicList.selected))
	if code == null:
		var new: logic = logic.new()
		new.unsplitCode = condition.get_text()
		new.save(Name.get_text())
	else:
		code.unsplitCode = condition.get_text()
		code.save(Name.get_text())
	
	refreshList()
