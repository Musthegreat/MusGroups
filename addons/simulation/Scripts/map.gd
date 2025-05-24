extends Control
signal savedMap

@export_category("Other")
@export var Graph: GraphEdit
@export var Group: PackedScene
@export var console: RichTextLabel

#region Basics
var lua: LuaState = LuaState.new()
var API: LuaTable = lua.create_table()

func _ready() -> void:
	
	MusGroups.sceneReferences["map"] = self
	MusGroups.sceneReferences["console"] = console
	
	#connect to signals relavent to map
	%uploadChanges.pressed.connect(func(): MusGroups.sceneReferences["editor"].uploadFiles())
	
	mapLoad()

func selectGroup(g) -> void:
	MusGroups.selectedGroup = g.Instance
	MusGroups.loadSelection()

func mapLoad() -> void:
	print(MusGroups.game)
	var m = map.loadMap()
	if m == null:
		print("whoops no map")
		var I: String = MusGroups.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
		var t: timer = timer.new()
		t.Instance = I
		t.Name = "Timer"
		t.save(MusGroups.identifier)
		allSave()
		mapLoad()
	else:
		for i in m.data:
			var g = Group.instantiate()
			g.dragged.connect(allSave.unbind(2))
			Graph.add_child(g)
			g.node_selected.connect(selectGroup.bind(g))
			g.Instance = m.data[i]["ID"]
			g.position_offset = m.data[i]["POS"]
			
			g.update(m.data[i]["ID"])
			g.selection.hide()
	MusGroups.sceneReferences["groupMenu"].update()

func groupAdd() -> void:
	# r is resource, I is instance ID
	var I: String = MusGroups.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var G = Group.instantiate()
	G.dragged.connect(allSave.unbind(2))
	Graph.add_child(G)
	G.node_selected.connect(selectGroup.bind(G))
	G.Instance = I
	
	var g = group.new()
	g.Instance = I
	g.Name = "group"
	g.save(MusGroups.identifier)
	
	allSave()

func groupAddExisting(Instance) -> void:
	var G = Group.instantiate()
	G.dragged.connect(allSave.unbind(2))
	Graph.add_child(G)
	G.node_selected.connect(selectGroup.bind(G))
	G.Instance = Instance
	G.update(Instance)
	
	allSave()

func componentAdd(type: GDScript, typeName: String) -> void:
	# r is resource, I is instance ID
	var I: String = MusGroups.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var G = Group.instantiate()
	Graph.add_child(G)
	G.dragged.connect(allSave.unbind(2))
	G.node_selected.connect(selectGroup.bind(G))
	G.Instance = I
	
	var g = type.new()
	g.Instance = I
	g.Name = typeName
	g.TypeName = typeName
	g.save(MusGroups.identifier)
	
	G.update(I)
	
	allSave()

func allSave() -> void:
	var m = map.new()
	for G in Graph.get_children():
		if G is groupVisual:
			m.append(G)
	m.save(MusGroups.identifier)
	savedMap.emit()
	
#endregion

func sendToServer() -> void:
	pass
