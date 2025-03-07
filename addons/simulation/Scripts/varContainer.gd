@tool
extends HBoxContainer
class_name varContainer
signal restart

var startIndex: int
var oldIndex: int
var varName: String
var varBox

@export var lineEdit: LineEdit
@export var optionButton: OptionButton
@export var delete: Button

func _enter_tree() -> void:
	optionButton.item_selected.connect(selectionChanged)
	delete.pressed.connect(onDelete)
	lineEdit.text_changed.connect(lineEdited)
	
	optionButton._select_int(startIndex)
	match startIndex:
		1: #if selection is INT
			varBox = SpinBox.new()
			add_child(varBox)
			
			varBox.set_step(1)
			varBox.set_use_rounded_values(true)
			varBox.set_allow_greater(true)
			varBox.set_allow_lesser(true)
		2: #if selection is FLOAT
			varBox = SpinBox.new()
			add_child(varBox)
			
			varBox.set_step(0.1)
			varBox.set_allow_greater(true)
			varBox.set_allow_lesser(true)
		3: #if selection is STRING
			varBox = LineEdit.new()
			add_child(varBox)
			
			varBox.set_placeholder("Enter string")
			varBox.set_h_size_flags(Control.SIZE_EXPAND_FILL)

		4: #if selection is BOOL
			varBox = OptionButton.new()
			add_child(varBox)
			
			varBox.add_item("true")
			varBox.add_item("false")
		_: 
			pass
	
	if startIndex != 0:
		lineEdit.set_editable(true)

func loadVar(vars: Dictionary) -> void:
	lineEdit.set_text(vars["Name"])
	match vars["Type"]:
		"int": #if selection is INT
			lineEdit.set_editable(true)
			optionButton._select_int(1)
			varBox = SpinBox.new()
			add_child(varBox)
			
			varBox.set_step(1)
			varBox.set_use_rounded_values(true)
			varBox.set_allow_greater(true)
			varBox.set_allow_lesser(true)
			
			varBox.set_value(vars["Data"])
		"float": #if selection is FLOAT
			lineEdit.set_editable(true)
			optionButton._select_int(2)
			varBox = SpinBox.new()
			add_child(varBox)
			
			varBox.set_step(0.1)
			varBox.set_allow_greater(true)
			varBox.set_allow_lesser(true)
			
			varBox.set_value(vars["Data"])
		"string": #if selection is STRING
			lineEdit.set_editable(true)
			optionButton._select_int(3)
			varBox = LineEdit.new()
			add_child(varBox)
			
			varBox.set_placeholder("Enter string")
			varBox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
			
			varBox.set_text(vars["Data"])
		"bool": #if selection is BOOL
			lineEdit.set_editable(true)
			optionButton._select_int(4)
			varBox = OptionButton.new()
			add_child(varBox)
			
			varBox.add_item("true")
			varBox.add_item("false")
			
			varBox._select_int(vars["Data"])
		_: 
			pass

func onDelete() -> void:
	queue_free()

func selectionChanged(index) -> void:
	#reset the name component if reselected the null type.
	if index == 0:
		lineEdit.set_text("")
		lineEdit.set_editable(false)
		
	if oldIndex != index:
		restart.emit(get_path(), index)
		
	else:
		oldIndex = index
	

func lineEdited(string) -> void:
	varName = string


func out() -> Dictionary:
	var output: Dictionary
	match startIndex:
		1:
			output = {"Type": "int", "Data": varBox.get_value(), "Name": varName}
			return output
		2:
			output = {"Type": "float", "Data": varBox.get_value(), "Name": varName}
			return output
		3:
			output = {"Type": "string", "Data": varBox.get_text(), "Name": varName}
			return output
		4:
			output = {"Type": "bool", "Data": varBox.get_item_text(varBox.get_selected()), "Name": varName}
			return output
		_:
			output = {"Type": "NULL", "Name": varName}
			return output
