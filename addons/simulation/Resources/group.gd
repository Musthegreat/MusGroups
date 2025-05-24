extends Resource
class_name group

@export var Name: String
@export var TypeName: String = "group"
@export var Instance: String
@export var Variables: Dictionary
@export var Logics: Array

var Menu: Array = [preload("res://addons/simulation/MusAPI/Basic/Components/empty/emtpy.tscn")]

func save(identifier) -> void:
	if MusGroups.checkIdentifier(identifier, "loadGroup") != true:
		Print.printErr(MusGroups.console, "Failed to load group with ID of " + Instance)
		return
	
	ResourceSaver.save(self, "user://games/"+MusGroups.game +"/" +MusGroups.context+ "/data/groups/" + MusGroups.fixFileName(Instance, ".tres"))

static func loadGroup(Instance: String, identifier: String) -> Resource:
	if MusGroups.checkIdentifier(identifier, "loadGroup") != true:
		Print.printErr(MusGroups.console, "Failed to load group with ID of " + Instance)
		return
		
	if ResourceLoader.exists("user://games/"+MusGroups.game +"/" +MusGroups.context+ "/data/groups/" + MusGroups.fixFileName(Instance, ".tres")):
		return ResourceLoader.load("user://games/"+MusGroups.game +"/" +MusGroups.context+ "/data/groups/" + MusGroups.fixFileName(Instance, ".tres"))
	else:
		return null

#region MusAPI
static func run(Instance: String) -> void:
	
	MusGroups.runQeueue.append(Instance)

static func getGroup(Instance: String): 
	return group.loadGroup(Instance, MusGroups.identifier)

func getVar(varName: String):
	if Variables.has(varName):
		if Variables[varName]["Type"] == "Array" or Variables[varName]["Type"] == "Dictionary":
			return str_to_var(Variables[varName]["Data"])
		else:
			return Variables[varName]["Data"]
	else:
		Print.apiErr("Variable of name " + varName + " not found in group " + Instance, MusGroups.identifier)

func getVarType(varName: String):
	return Variables[varName]["Type"]

func setVar(varName: String, data: Variant) -> void:
	for a in Variables:
		if Variables[a]["Name"] == varName:
			var Error: bool = false
			match Variables[a]["Type"]:
				"int":
					if data is int:
						Variables[a]["Data"] = data
					else:
						Error = true
				"float":
					if data is float:
						Variables[a]["Data"] = data
					else:
						Error = true
				"String":
					if data is String:
						Variables[a]["Data"] = data
					else:
						Error = true
				"bool":
					if var_to_str(data) == "true" or var_to_str(data) == "false":
						Variables[a]["Data"] = var_to_str(data)
					else:
						Error = true
				"Array":
					if data is Array:
						Variables[a]["Data"] = var_to_str(data)
					else:
						Error = true
				"Dictionary":
					if data is Dictionary:
						Variables[a]["Data"] = var_to_str(data)
					else:
						Error = true
			
			if Error == true:
				Print.apiErr("Error setting variable, the type provided does not match type of variable " + varName + " which is " + type_string(typeof(Variables[a]["Data"])), MusGroups.identifier)
				
	save(MusGroups.identifier)
	MusGroups.selectedGroup = Instance
	MusGroups.loadSelection()

func runLogic(logicInstance: String) -> void:
	var l: logic = logic.loadLogic(logicInstance, MusGroups.identifier)
	
	MusGroups.API["This"] = self
	MusGroups.lua.do_string(l.unsplitCode, "", MusGroups.API)

func addLogic(logicInstance: String) -> void:
	Logics.append(logicInstance)
	
	save(MusGroups.identifier)
	MusGroups.selectedGroup = Instance
	MusGroups.loadSelection()

func removeLogic(logicInstance: String) -> void:
	Logics.remove_at(Logics.find(logicInstance))
	
	save(MusGroups.identifier)
	MusGroups.selectedGroup = Instance
	MusGroups.loadSelection()

func clone() -> void:
	var currentMap = MusGroups.sceneReferences["map"]
	
	# r is resource, I is instance ID
	var I: String = MusGroups.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var g = currentMap.Group.instantiate()
	g.dragged.connect(currentMap.allSave)
	currentMap.Graph.add_child(g)
	g.node_selected.connect(currentMap.selectGroup.bind(g))
	g.Instance = I
	
	var r = group.new()
	r.Instance = I
	r.Name = Name
	r.Logics = Logics
	r.Variables = Variables
	
	r.save(MusGroups.identifier)
	
	g.update(I)
	
	currentMap.allSave()
#endregion
