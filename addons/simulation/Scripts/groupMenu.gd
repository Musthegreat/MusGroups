extends Control

@export var button: Button
@export var container: VBoxContainer
@export var groupAdder: PackedScene
@export var maps: Control

func _ready() -> void:
	button.pressed.connect(refresh)
	maps.savedMap.connect(refresh)
	Singleton.game = "bust city"
	Singleton.groupMenu = self

func update() -> void:
	var groups = Singleton.loadLists("groups")
	
	for i in groups: 
		var new = groupAdder.instantiate()
		container.add_child(new)
		new.uponDelete.connect(refresh)
		
		var g: group = group.loadGroup(Singleton.fixFileName(i, ""), Singleton.identifier)
		new.maps = maps
		new.onLoad(g)

func refresh() -> void:
	for child in container.get_children():
		if child is not Button:
			child.queue_free()
		
	update()
