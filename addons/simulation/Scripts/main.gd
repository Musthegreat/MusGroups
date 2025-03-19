@tool
extends EditorPlugin

func _enter_tree() -> void:
	#create dir if not made
	Singleton.firstLoad()
	
func _exit_tree() -> void:
	pass

func _get_plugin_name() -> String:
	return "SIMULATION"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
