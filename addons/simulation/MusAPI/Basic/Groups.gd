extends Object
class_name Groups

#region Search
static func searchByName(graph: GraphEdit, name: String, targets: Array = []):
	for a in graph.get_children():
		if a is groupVisual and a.Name == name:
			targets.append(a.instance)
	print(targets)
	return targets
	
static func searchByVar(graph: GraphEdit, varName: String, type = null, targets: Array = []):
	if type == null:
		for a in graph.get_children():
			if a is groupVisual:
				var G = group.loadGroup(a.instance, Singleton.identifier)
				for b in G.Variables:
					if G.Variables[b]["Name"] == varName:
						targets.append(a.instance)
		print(targets)
		return targets
	
	for a in graph.get_children():
		if a is groupVisual:
			var G = group.loadGroup(a.instance, Singleton.identifier)
			for b in G.Variables:
				if G.Variables[b]["Name"] == varName and G.Variables[b]["Type"] == type:
					targets.append(a.instance)
	print(targets)
	return targets
	
static func getVar(Instance: String, varName: String) -> Variant:
	var G: group = group.loadGroup(Instance, Singleton.identifier)
	
	if G.Variables.has(varName):
		return G.Variables[varName]["Data"]
	else:
		Print.apiErr("Variable of name " + varName + " not found in group " + Instance, Singleton.identifier)
		
	return null
#endregion

#region Modify
static func clone(Instance: String) -> void:
	var currentMap = Singleton.maps
	var cloner: group = group.loadGroup(Instance, Singleton.identifier)
	
	# r is resource, I is instance ID
	var I: String = Singleton.generateWord("abcdefghijABDEFGHIJ1234567890", 10)
	
	var g = currentMap.Group.instantiate()
	currentMap.Graph.add_child(g)
	g.node_selected.connect(currentMap.selectGroup.bind(g))
	g.Instance = I
	
	var r = group.new()
	r.Instance = I
	r.Name = cloner.Name
	r.Logics = cloner.Logics
	r.Variables = cloner.Variables
	
	r.save(Singleton.identifier)
	
	g.update(I)
	
	currentMap.allSave()
	
static func removeByID(Instance: String) -> void:
	var currentMap = Singleton.maps
	
	var foundOne: bool = false
	for a in currentMap.Graph.get_children():
		if a is groupVisual and a.Instance == Instance:
			foundOne = true
			
			a.free()
		
	if foundOne == false:
		Print.apiErr("Error removing group by ID, could not find any groups with id of " + Instance, Singleton.identifier)
	currentMap.allSave()
	
static func removeByName(Name: String) -> void:
	var currentMap = Singleton.maps
	
	var foundOne: bool = false
	for a in currentMap.Graph.getChildren():
		if a is groupVisual and a.Name == Name:
			foundOne = true
			
			a.free()
			
	Print.apiErr("Error removing group by Name, could not find any groups with Name of " + Name, Singleton.identifier)
	currentMap.allSave()
	
static func setVar(Instance: String, varName: String, data: Variant) -> void:
	var G: group = group.loadGroup(Instance, Singleton.identifier)
	
	for a in G.Variables:
		if G.Variables[a]["Name"] == varName:
			var Error: bool = false
			match G.Variables[a]["Type"]:
				"int":
					if data is int:
						G.Variables[a]["Data"] = data
					else:
						Error = true
				"float":
					if data is float:
						G.Variables[a]["Data"] = data
					else:
						Error = true
				"string":
					if data is String:
						G.Variables[a]["Data"] = data
					else:
						Error = true
				"bool":
					if var_to_str(data) == "true" or var_to_str(data) == "false":
						G.Variables[a]["Data"] = var_to_str(data)
					else:
						Error = true
			
			if Error == true:
				Print.apiErr("Error setting variable, the type provided does not match type of variable " + varName + " which is " + type_string(typeof(G.Variables[a]["Data"])), Singleton.identifier)
		else:
			match typeof(data):
				TYPE_INT:
					G.Variables[varName] = {"Type": "int", "Data": data, "Name": varName}
				TYPE_FLOAT:
					G.Variables[varName] = {"Type": "float", "Data": data, "Name": varName}
				TYPE_STRING:
					G.Variables[varName] = {"Type": "string", "Data": data, "Name": varName}
				TYPE_BOOL:
					G.Variables[varName] = {"Type": "bool", "Data": var_to_str(data), "Name": varName}
		
	G.save(Singleton.identifier)
	Singleton.selectedGroup = Instance
	Singleton.loadSelection()
#endregion
