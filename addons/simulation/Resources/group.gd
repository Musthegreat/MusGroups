extends Resource
class_name group

@export var Name: String
@export var Instance: String
@export var Variables: Dictionary
@export var Logics: Array

func save(identifier) -> void:
	if Singleton.checkIdentifier(identifier, "loadGroup") != true:
		Print.printErr(Singleton.console, "Failed to load group with ID of " + Instance)
		return
	
	#var collection: FirestoreCollection = Firebase.Firestore.collection(Singleton.game)
	#var document: FirestoreDocument = Firebase.
	#var task: FirestoreTask = collection.update("data")
	
	ResourceSaver.save(self, "user://"+Singleton.game +"/data/groups/" + Singleton.fixFileName(Instance, ".tres"))

static func loadGroup(Instance: String, identifier: String) -> Resource:
	if Singleton.checkIdentifier(identifier, "loadGroup") != true:
		Print.printErr(Singleton.console, "Failed to load group with ID of " + Instance)
		return
		
	if ResourceLoader.exists("user://"+Singleton.game +"/data/groups/" + Singleton.fixFileName(Instance, ".tres")):
		return ResourceLoader.load("user://"+Singleton.game +"/data/groups/" + Singleton.fixFileName(Instance, ".tres")) as group
	else:
		return null

#region MusAPI
static func getGroup(Instance: String) -> group:
	return group.loadGroup(Instance, Singleton.identifier)

func getVar(varName: String):
	if Variables.has(varName):
		if Variables[varName]["Type"] == "Array"  or "Dictionary":
			return str_to_var(Variables[varName]["Data"])
		else:
			return Variables[varName]["Data"]
	else:
		Print.apiErr("Variable of name " + varName + " not found in group " + Instance, Singleton.identifier)

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
					if data is String:
						Variables[a]["Data"] = data
					else:
						Error = true
				"Dictionary":
					if data is String:
						Variables[a]["Data"] = data
					else:
						Error = true
			
			if Error == true:
				Print.apiErr("Error setting variable, the type provided does not match type of variable " + varName + " which is " + type_string(typeof(Variables[a]["Data"])), Singleton.identifier)
		else:
			pass
			#match typeof(data):
				#TYPE_INT:
					#Variables[varName] = {"Type": type_string(TYPE_INT), "Data": data, "Name": varName}
				#TYPE_FLOAT:
					#Variables[varName] = {"Type": type_string(TYPE_FLOAT), "Data": data, "Name": varName}
				#TYPE_STRING:
					#Variables[varName] = {"Type": type_string(TYPE_STRING), "Data": data, "Name": varName}
				#TYPE_BOOL:
					#Variables[varName] = {"Type": type_string(TYPE_BOOL), "Data": var_to_str(data), "Name": varName}
				#TYPE_ARRAY:
					#Variables[varName] = {"Type": type_string(TYPE_ARRAY), "Data": data, "Name": varName}
		
	save(Singleton.identifier)
	Singleton.selectedGroup = Instance
	Singleton.loadSelection()

func addLogic(logicName: String) -> void:
	Logics.append(logicName + ".tscn")
	
	save(Singleton.identifier)
	Singleton.selectedGroup = Instance
	Singleton.loadSelection()

func removeLogic(logicName: String) -> void:
	Logics.remove_at(Logics.find(logicName))
	
	save(Singleton.identifier)
	Singleton.selectedGroup = Instance
	Singleton.loadSelection()

func clone() -> void:
	var currentMap = Singleton.maps
	
	# r is resource, I is instance ID
	var I: String = Singleton.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
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
	
	r.save(Singleton.identifier)
	
	g.update(I)
	
	currentMap.allSave(Vector2(0,0), Vector2(0,0))
#endregion
