extends Control

func _ready() -> void:
	%Editor.switchTab.connect(switchTab)

func switchTab(tab: String) -> void:
	match tab:
		"Logic":
			%TabContainer.set_current_tab(2)
		_:
			return
