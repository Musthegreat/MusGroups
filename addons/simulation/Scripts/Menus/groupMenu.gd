extends Control

@export var button: Button
@export var container: VBoxContainer
@export var groupAdder: PackedScene
@export var maps: Control

func _ready() -> void:
	button.pressed.connect(refresh)
	maps.savedMap.connect(refresh)
	MusGroups.game = "bust city"
	MusGroups.sceneReferences["groupMenu"] = self

func update() -> void:
	var groups = MusGroups.loadLists("groups")
	
	for i in groups: 
		var new = groupAdder.instantiate()
		container.add_child(new)
		new.uponDelete.connect(refresh)
		
		var g = group.loadGroup(MusGroups.fixFileName(i, ""), MusGroups.identifier)
		new.maps = maps
		if g != null:
			new.onLoad(g)

func refresh() -> void:
	for child in container.get_children():
		if child is not Button:
			child.queue_free()
		
	update()
