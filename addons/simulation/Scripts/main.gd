@tool
extends EditorPlugin

const logicMenu: PackedScene = preload("res://addons/simulation/logicMenu.tscn")
const varMenu: PackedScene = preload("res://addons/simulation/varMenu.tscn")
const Simulation: PackedScene = preload("res://addons/simulation/simulationMenu.tscn")
var menuInstance
var logicMenuInstance
var varMenuInstance

func _enter_tree() -> void:
		#create dir if not made
	Singleton.firstLoad()
	
	menuInstance = Simulation.instantiate()
	logicMenuInstance = logicMenu.instantiate()
	varMenuInstance = varMenu.instantiate()
	_make_visible(false)
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, menuInstance)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, varMenuInstance)
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, logicMenuInstance)
	
func _exit_tree() -> void:
	remove_control_from_docks(menuInstance)
	menuInstance.queue_free()
	remove_control_from_docks(logicMenuInstance)
	logicMenuInstance.queue_free()
	remove_control_from_docks(varMenuInstance)
	varMenuInstance.queue_free()

func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "SIMULATION"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
