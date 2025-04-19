extends Control
signal uponDelete

var Instance: String
var maps: Control

func _ready() -> void:
	%Button.pressed.connect(add)
	%Button2.pressed.connect(delete)

func onLoad(g) -> void:
	redundancyCheck(g.Instance)
	
	Instance = g.Instance
	
	%Instance.set_text(g.Instance)
	%Label.set_text(g.Name)
	
	for i in g.Variables:
		var label: Label = Label.new()
		%VBoxContainer.add_child(label)
		label.set_text(g.Variables[i]["Name"] + ": " + var_to_str(g.Variables[i]["Data"]))

func redundancyCheck(Instance) -> void:
	for a in maps.Graph.get_children():
		if a is groupVisual:
			print("YES")
			if Instance == a.Instance:
				print("YES")
				queue_free()

func add() -> void:
	maps.groupAddExisting(Instance)
	queue_free()

func delete() -> void:
	uponDelete.emit()
	
	DirAccess.remove_absolute("user://"+Singleton.game +"/data/groups/" + Instance + ".tres")
	queue_free()
