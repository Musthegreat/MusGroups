extends Object
class_name Groups

#region Search
static func searchByName(name: String, targets: Array = []):
	var dir: map = map.loadMap()
	for i in dir.data:
		var g = group.loadGroup(i, MusGroups.identifier)
		if g.Name == name:
			targets.append(g.Instance)
	return targets
	
static func searchByVar(varName: String, type = null, targets: Array = []):
	var dir: map = map.loadMap()
	if type == null:
		for i in dir.data:
			var g = group.loadGroup(i, MusGroups.identifier)
			for a in g.Variables:
				if g.Variables[a]["Name"] == varName:
					targets.append(g.Instance)
		return targets
	
	for i in dir.data:
		var g = group.loadGroup(i, MusGroups.identifier)
		for a in g.Variables:
			if g.Variables[a]["Name"] == varName and g.Variables[a]["Type"] == type:
				targets.append(a.instance)
	return targets
	
static func getVar(Instance: String, varName: String) -> Variant:
	var G: group = group.loadGroup(Instance, MusGroups.identifier)
	return G.getVar(varName)

static func run(targets: Array) -> void:
	MusGroups.runQeueue.append_array(targets)
#endregion

#region Modify
static func removeByID(Instance: String) -> void:
	var currentMap = MusGroups.maps
	
	var foundOne: bool = false
	for a in currentMap.Graph.get_children():
		if a is groupVisual and a.Instance == Instance:
			foundOne = true
			
			a.free()
		
	if foundOne == false:
		Print.apiErr("Error removing group by ID, could not find any groups with id of " + Instance, MusGroups.identifier)
	currentMap.allSave()
	
static func removeByName(Name: String) -> void:
	var currentMap = MusGroups.maps
	
	var foundOne: bool = false
	for a in currentMap.Graph.getChildren():
		if a is groupVisual and a.Name == Name:
			foundOne = true
			
			a.free()
			
	Print.apiErr("Error removing group by Name, could not find any groups with Name of " + Name, MusGroups.identifier)
	currentMap.allSave()
	
static func setVar(targets: Array, varName: String, data: Variant) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, MusGroups.identifier)
		G.setVar(varName, data)

static func addLogic(targets: Array, logicName: String) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, MusGroups.identifier)
		G.addLogic(logicName)

static func removeLogic(targets: Array, logicName: String) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, MusGroups.identifier)
		G.removeLogic(logicName)

static func clone(targets: Array) -> void:
	for i in targets:
		var G: group = group.loadGroup(i, MusGroups.identifier)
		G.clone()
#endregion
