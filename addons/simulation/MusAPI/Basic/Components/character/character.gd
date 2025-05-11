extends visual
class_name character

@export var characterInspector: PackedScene = preload("res://addons/simulation/MusAPI/Basic/Components/character/characterInspector.tscn")
@export var health: int
@export var inventory: Dictionary
@export var speed: int

func _init() -> void:
	Menu.append(characterInspector)

#region MusAPI
func addItem(Instance) -> void:
	var g = group.loadGroup(Instance, MusGroups.identifier)
	if inventory.has(Instance):
		inventory[Instance]["Count"] = inventory[Instance]["Count"] + 1
	else:
		inventory[Instance] = {"Instance": Instance, "Name": g.Name, "Count": 1}

func removeItem(Instance) -> void:
	var g = group.loadGroup(Instance, MusGroups.identifier)
	if !inventory.has(Instance):
		Print.printErr(MusGroups.sceneReferences["console"], "Inventory error, unable to remove item from " + self.Name + " because the item isnt in the inventory")
	elif inventory[Instance]["Count"] > 1:
		inventory[Instance]["Count"] -= 1
	else: 
		inventory.erase(Instance)
#endregion
