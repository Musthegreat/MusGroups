extends Object
class_name Groups

#region Search
static func byName(graph: GraphEdit, name: String, targets: Array = []):
	for a in graph.get_children():
		if a is groupVisual and a.Name == name:
			targets.append(a.instance)
	print(targets)
	return targets
		
static func byVar(graph: GraphEdit, varName: String, type = null, targets: Array = []):
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
#endregion

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
static func remove(Instance: String) -> void:
	pass

static func setVar(Instance: String, varName: String, data: Variant) -> void:
	pass
