extends Control

var PackedContainer: PackedScene = preload("res://addons/simulation/Scenes/varContainer.tscn")
@export var saveUpdate: Button
@export var newVairable: Button
@export var vBox: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	newVairable.pressed.connect(VariablePressed)
	saveUpdate.pressed.connect(savePressed)
	Singleton.loadSelected.connect(loadSequence)

func VariablePressed() -> void:
	var newContainer: HBoxContainer = PackedContainer.instantiate()
	newContainer.restart.connect(onRestart)
	newContainer.startIndex = 0
	vBox.add_child(newContainer)
	
func onRestart(path, index) -> void:
	get_node(path).queue_free()
	
	var newContainer: HBoxContainer = PackedContainer.instantiate()
	newContainer.restart.connect(onRestart)
	newContainer.startIndex = index
	vBox.add_child(newContainer)

func savePressed() -> void:
	var g = group.loadGroup(Singleton.selectedGroup)
	if g is group:
		#gotta erase everything so changes to existing vars apply
		g.Variables.clear()
		for child in vBox.get_children():
			if child is varContainer:
				g.Variables[child.varName] = child.out()
		g.save()
	else:
		g = group.new()
		g.Instance = Singleton.selectedGroup
		for child in vBox.get_children():
			if child is varContainer:
				g.Variables[child.varName] = child.out()
		g.save()

func loadSequence(selectedGroup) -> void:
	#enable the button once a node selected signal is recieved. because logically a node will always be selected after the first one.
	newVairable.set_disabled(false)
	
	#delete all the variables from the previously selected node.
	for child in vBox.get_children():
		if child is varContainer:
			child.queue_free()
	
	#create the new variables and populate them from info from the json file.
	var g = group.loadGroup(Singleton.selectedGroup)
	if g is group:
		for i in g.Variables:
			var newContainer: HBoxContainer = PackedContainer.instantiate()
			newContainer.restart.connect(onRestart)
			vBox.add_child(newContainer)
			newContainer.loadVar(g.Variables[i])
	else:
		print("whoops no vars")
