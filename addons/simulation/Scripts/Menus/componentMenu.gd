extends Control

@export var componentContainer: PackedScene

func _ready() -> void:
	for i in MusGroups.componentList.size():
		var new = componentContainer.instantiate()
		%VBoxContainer.add_child(new)
		new.type = MusGroups.componentList[i]
		new.typeName = MusGroups.componentNamesList[i]
		new.setName()
