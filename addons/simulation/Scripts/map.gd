extends Control

@export_category("Buttons")
@export var addGroup: Button
@export var saveAll: Button
@export var stepSimulation: Button

@export_category("Other")
@export var Graph: GraphEdit
@export var Group: PackedScene

#region Basics
func _ready() -> void:
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

func groupAdd() -> void:
	# r is resource, I is instance ID
	var I: String = Singleton.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var g = Group.instantiate()
	Graph.add_child(g)
	g.node_selected.connect(selectGroup.bind(g))
	g.Instance = I
	
	var r = group.new()
	r.Instance = I
	r.save()

func allSave() -> void:
	var m = map.new()
	for i in Graph.get_children():
		if i is GraphElement:
			m.append(i)
		m.save()
#endregion

var G: group

var curr: int = 0
var executing: bool = true
var target: String
var memoryID: Array
var memoryName: Array

func main() -> void:
	#start with a list of all groups
	var l: PackedStringArray = Singleton.loadLists("groups")
	
	#load each group in the list
	for a in Graph.get_children():
		if a is groupVisual:
			G = group.loadGroup(a.Instance)
			#load each logic in the group
			for b in G.Logics:
				if executing == true:
					var L = logic.loadLogic(b)
					parse(L)

func parse(L: logic) -> void:
	if curr < L.splitCode.size():
		match L.splitCode[curr]:
			"if":
				target = L.splitCode[curr + 1]
				curr += 2
				match L.splitCode[curr]:
					"has":
						has(L.splitCode[curr + 1], L.splitCode[curr + 2])
						curr += 3
						parse(L)
					"var":
						if L.splitCode[curr + 3] == "num":
							if varNumber(L.splitCode[curr + 1], L.splitCode[curr + 4], L.splitCode[curr + 2]):
								print("comparisontrue")
								curr += 5
							else:
								curr = L.splitCode.size()
						elif L.splitCode[curr + 3] == "self":
							if varNumber(L.splitCode[curr + 1],L.splitCode[curr + 2],L.splitCode[curr + 3]):
								print("comparison true")
								curr += 4
							else:
								curr = L.splitCode.size()
						elif L.splitCode[curr + 3] == "else":
							if varElse(L.splitCode[curr + 1],L.splitCode[curr + 2],L.splitCode[curr + 3]):
								print("comparison true")
								curr += 4
							else:
								curr = L.splitCode.size()
						else:
							print("error, did not find correct comparrison type")
							reset()
					_:
						curr = 0
						print("unknown function " + L.splitCode[curr])
			"then":
				curr += 1
			_:
				print("unknown decleration " + L.splitCode[curr])
				reset()
	else:
		curr = 0

func has(name: String, type: String) -> void:
	print("has")
	if target == "any":
		for a in Graph.get_children():
			if a is groupVisual:
				var gr: group = group.loadGroup(a.Instance)
				if gr.Variables.has(name):
					if gr.Variables[name]["Type"] == type:
						memoryID.append(gr.Instance)
						memoryID.append(gr.Name)
						print("success")
					else:
						print(name, gr.Variables.has(name))
						print("Variable of type " + type + " not found, instead found " + gr.Variables[name]["Type"] + gr.Instance)
				else:
					print("Variable of type " + type + " not found " + G.Instance)
	elif target == "self":
		if G.Variables.has(name):
			if G.Variables[name]["Type"] == type:
				print("success")
			else:
				print(name, G.Variables.has(name))
				print("Variable of type " + type + " not found, instead found " + G.Variables[name]["Type"] + G.Instance)
		else:
			print("Variable of type " + type + " not found " + G.Instance)
	else:
		for a in Graph.get_children():
			if a is groupVisual and a.Name == target:
				var gr: group = group.loadGroup(a.Instance)
				if gr.Variables.has(name):
					if gr.Variables[name]["Type"] == type:
						memoryID.append(gr.Instance)
						memoryID.append(gr.Name)
						print("success")
					else:
						print(name, gr.Variables.has(name))
						print("Variable of type " + type + " not found, instead found " + gr.Variables[name]["Type"] + gr.Instance)
				else:
					print("Variable of type " + type + " not found " + G.Instance)

func varNumber(name: String, comp: String, number: String) -> bool:
	var num = str_to_var(number)
	if target != "self":
		print("error, expected 'self' when calling function var, instead got" + target)
		executing = false
		return false
	var var1 = G.Variables[name]["Data"]
	var mode: int
	match G.Variables[name]["Type"]:
		"float":
			mode = 1
		"int":
			mode = 1
		"string":
			mode = 2
		"bool":
			mode = 2
	if mode == 1:
		match comp:
			"=":
				if var1 == num:
					return true
			"!=":
				if var1 != num:
					return true
			">=":
				if var1 >= num:
					return true
			"<=":
				if var1 <= num:
					return true
			">":
				if var1 > num:
					return true
			"<":
				if var1 < num:
					return true
			_:
				print("error, invalid comparrison '" + comp + "'")
				executing == false
				return false
				
				
	elif mode == 2:
		match comp:
			"=":
				if var1 == num:
					return true
			"!=":
				if var1 != num:
					return true
			_:
				return false
				print("error, invalid comparrison " + comp)
	print("untrue comparrison")
	return false

func varSelf(name1: String, name2: String, comp: String) -> bool:
	return false

func varElse(name1: String, name2: String, comp: String) -> bool:
	var var1 = G.Variables[name1]["Data"]
	var var2
	
	for a in memoryName:
		if a == name2:
			pass
		else:
			for b in Graph.get_children():
				if b is groupVisual:
					if b.Name == name2:
						pass
	return false

func reset() -> void:
	executing == false
	curr = 0
