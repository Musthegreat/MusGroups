extends Object
class_name Groups

#region Search
static func searchByName(graph: GraphEdit, name: String, targets: Array = []):
	for a in graph.get_children():
		if a is groupVisual and a.Name == name:
			targets.append(a.Instance)
	print(targets)
	return targets
	
static func searchByVar(graph: GraphEdit, varName: String, type = null, targets: Array = []):
	if type == null:
		for a in graph.get_children():
			if a is groupVisual:
				var G = group.loadGroup(a.Instance, Singleton.identifier)
				for b in G.Variables:
					if G.Variables[b]["Name"] == varName:
						targets.append(a.Instance)
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
	return G.getVar(varName)
#endregion

#region Modify
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
	
static func setVar(targets: Array, varName: String, data: Variant) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, Singleton.identifier)
		G.setVar(varName, data)

static func addLogic(targets: Array, logicName: String) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, Singleton.identifier)
		G.addLogic(logicName)

static func removeLogic(targets: Array, logicName: String) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, Singleton.identifier)
		G.removeLogic(logicName)

static func clone(targets: Array) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, Singleton.identifier)
		G.clone()
#endregion
