extends Control
signal switchTab

@export var conditionContainer: VBoxContainer
@export var logicList: ItemList
@export var saveButton: Button
@export var Name: LineEdit

@export var condition: CodeEdit

var list: Array
var toggle: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusGroups.sceneReferences["inspector"].openLogic.connect(openLogic)
	MusGroups.newGame("bust city")
	logicList.item_selected.connect(loadLogic)
	saveButton.pressed.connect(save)
	
	%createLogicButton.pressed.connect(createLogic)
	%Delete.pressed.connect(deleteLogic)
	%babyMode.toggled.connect(babyMode)
	
	condition.text_changed.connect(autoComplete)
	condition.code_completion_enabled = true
	
	refreshList()

#region Code Completion
func babyMode(toggled_on) -> void:
	toggle = toggled_on

func autoComplete() -> void:
	if toggle == false:
		return
	
	var This = [":getVar()", ":setVar()", "run()", ".Instance", ".Name"]
	var Group = [":getVar()", ":setVar()", ":run()", ":searchByName()", ":searchByVar()"]
	var ThisDesc = [':getVar([variableName: String])', ':setVar([variableName: String], [data])', "run([Instance: String])", ".Instance", ".Name"]
	var GroupDesc = [':getVar([Instance: String], [variableName: String])', ':setVar([Targets: Array], [variableName: String], [data])', ":run([Targets: Array])", ":searchByName([Name: String], [Targets: Array = [])",":searchByVar([varName: String], [varType: String = null], [Targets: Array = []])"]
	
	
	for i in This.size():
		condition.add_code_completion_option(CodeEdit.KIND_FUNCTION, "This" + ThisDesc[i], "This" + This[i])
		
	for i in Group.size():
		condition.add_code_completion_option(CodeEdit.KIND_FUNCTION, "Groups" + GroupDesc[i], "Groups" + Group[i])
		
	condition.update_code_completion_options(true)
#endregion

func openLogic(Instance) -> void:
	loadLogic(list.find(Instance))
	switchTab.emit("Logic")

func refreshList(selected: int = 0) -> void:
	logicList.clear()
	
	var dir = MusGroups.loadLists("logic")
	for i in dir:
		var l: logic = logic.loadLogic(MusGroups.fixFileName(i, ""), MusGroups.identifier)
		var index: int = logicList.add_item(l.Name + " - " + l.Instance)
		logicList.set_item_metadata(index, l.Instance)
		list.append(l.Instance)
	
	Name.set_text(logicList.get_item_text(selected))
	if MusGroups.logicList.size() > 0:
		loadLogic(selected)

func loadLogic(index: int) -> void:
	Name.set_editable(true)
	logicList.select(index)
	
	var selected = logicList.get_item_text(index)
	
	var l: logic = logic.loadLogic(logicList.get_item_metadata(index), MusGroups.identifier)
	if l != null:
		condition.set_text(l.unsplitCode)
		Name.set_text(l.Name)

func createLogic() -> void:
	Name.set_editable(true)
	
	var l: logic = logic.new()
	l.Name = "logicName"
	l.Instance = MusGroups.generateWord("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890", 10)
	l.save(l.Instance, MusGroups.identifier)
	MusGroups.logicList[l.Instance] = {"Name": l.Name, "Instance": l.Instance}
	Name.set_text("logicName")
	condition.set_text("")
	
	var index: int = logicList.add_item("logicName - " + l.Instance)
	logicList.set_item_metadata(index, l.Instance)
	logicList.select(index)
	list.append(l.Instance)

func save() -> void:
	if logicList.is_anything_selected():
		var selected = logicList.get_selected_items()[0]
		var l: logic = logic.loadLogic(logicList.get_item_metadata(selected), MusGroups.identifier)
		print(logicList.get_item_metadata(selected))
		if l != null:
			print(logicList.get_item_metadata(selected))
			l.unsplitCode = condition.get_text()
			l.Name = Name.get_text()
			l.save(logicList.get_item_metadata(selected), MusGroups.identifier)
			MusGroups.logicList[l.Instance] = {"Name": l.Name, "Instance": l.Instance}
		refreshList(logicList.get_selected_items()[0])

func deleteLogic() -> void:
	if logicList.is_anything_selected():
		var selected: int = logicList.get_selected_items()[0]
		var Instance: String = logicList.get_item_metadata(selected)
		MusGroups.removeFile(MusGroups.fixFileName(Instance, ".tres"), "logic")
		refreshList()
		
		var dir = MusGroups.loadLists("groups")
		for i in dir:
			var g: group = group.loadGroup(i, MusGroups.identifier)
			g.Logics.remove_at(g.Logics.find(Instance))
			g.save(MusGroups.identifier)
