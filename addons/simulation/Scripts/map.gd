extends Control
signal savedMap

@export_category("Buttons")
@export var addGroup: Button
@export var saveAll: Button
@export var stepSimulation: Button

@export_category("Other")
@export var Graph: GraphEdit
@export var Group: PackedScene
@export var console: RichTextLabel

#region Basics
var lua: LuaState = LuaState.new()
var API: LuaTable = lua.create_table()

func hookAPI() -> void:
	API["This"] = null
	API["Graph"] = Graph
	API["Groups"] = Groups
	API["pront"] = Print.luaPrint

func _ready() -> void:
	Singleton.game = "bust city"
	Singleton.identifier = Singleton.generateWord("bus", 5)
	Singleton.console = console
	Singleton.maps = self
	
	lua.open_libraries(LuaState.GODOT_VARIANT)
	hookAPI()
	
	#connect to signals relavent to map
	addGroup.button_down.connect(groupAdd)
	saveAll.button_down.connect(allSave)
	stepSimulation.button_down.connect(main)
	
	mapLoad()

func selectGroup(g) -> void:
	Singleton.selectedGroupNode = g
	Singleton.selectedGroup = g.Instance
	Singleton.loadSelection()

func mapLoad() -> void:
	print(Singleton.game)
	var m = map.loadMap()
	if m == null:
		print("whoops no map")
	else:
		for i in m.data:
			var g = Group.instantiate()
			g.dragged.connect(allSave)
			Graph.add_child(g)
			g.node_selected.connect(selectGroup.bind(g))
			g.Instance = m.data[i]["ID"]
			g.position_offset = m.data[i]["POS"]
			
			g.update(m.data[i]["ID"])
	Singleton.inspector.update()

func groupAdd() -> void:
	# r is resource, I is instance ID
	var I: String = Singleton.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var g = Group.instantiate()
	g.dragged.connect(allSave)
	Graph.add_child(g)
	g.node_selected.connect(selectGroup.bind(g))
	g.Instance = I
	
	var r = group.new()
	r.Instance = I
	r.Name = "group"
	r.save(Singleton.identifier)
	
	allSave(Vector2(0,0), Vector2(0,0))

func groupAddExisting(Instance) -> void:
	var r: group = group.loadGroup(Instance, Singleton.identifier)
	print(r)
	var g = Group.instantiate()
	g.dragged.connect(allSave)
	Graph.add_child(g)
	g.node_selected.connect(selectGroup.bind(g))
	g.Instance = Instance
	g.update(Instance)
	
	allSave(Vector2(0,0), Vector2(0,0))

func allSave(from, to) -> void:
	var m = map.new()
	for g in Graph.get_children():
		if g is groupVisual:
			m.append(g)
	m.save()
	savedMap.emit()
	
#endregion
func main() -> void:
	#load each group in the list
	for a in Graph.get_children():
		if a is groupVisual:
			var g: group = group.loadGroup(a.Instance, Singleton.identifier)
			#load each logic in the group
			for b in g.Logics:
					var l: logic = logic.loadLogic(b, Singleton.identifier)
					API["This"] = g
					var result = lua.do_string(l.unsplitCode, "", API)
					if result is LuaError:
						Print.printErr(console, result)
