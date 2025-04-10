extends Control

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
	Singleton.selectedGroup = g.Instance
	Singleton.loadSelection()

func mapLoad() -> void:
	var m = map.loadMap()
	if m == null:
		print("whoops no map")
	else:
		for i in m.data:
			var g = Group.instantiate()
			Graph.add_child(g)
			g.node_selected.connect(selectGroup.bind(g))
			g.Instance = m.data[i]["ID"]
			g.position_offset = m.data[i]["POS"]
			
			g.update(m.data[i]["ID"])

func groupAdd() -> void:
	# r is resource, I is instance ID
	var I: String = Singleton.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var g = Group.instantiate()
	Graph.add_child(g)
	g.node_selected.connect(selectGroup.bind(g))
	g.Instance = I
	
	var r = group.new()
	r.Instance = I
	r.Name = "group"
	r.save(Singleton.identifier)

func allSave() -> void:
	var m = map.new()
	for g in Graph.get_children():
		if g is groupVisual:
			m.append(g)
		m.save()
	
	print("saved everything")
#endregion

var executing: bool = true

func main() -> void:
	#start with a list of all groups
	var l: PackedStringArray = Singleton.loadLists("groups")
	
	#load each group in the list
	for a in Graph.get_children():
		if a is groupVisual:
			var G: group = group.loadGroup(a.Instance, Singleton.identifier)
			#load each logic in the group
			for b in G.Logics:
				if executing == true:
					var L = logic.loadLogic(b, Singleton.identifier)
					API["This"] = G
					var result = lua.do_string(L.unsplitCode, "", API)
					if result is LuaError:
						Print.printErr(console, result)
