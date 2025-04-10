extends Control

@export var Margin: VBoxContainer
@export var Group: PackedScene

func _ready() -> void:
	var groups = Singleton.loadLists("groups")
	
	for a in groups:
		var r = Group.instantiate()
		
		Margin.add_child(r)
		r.update(Singleton.fixFileName(a, ""))
