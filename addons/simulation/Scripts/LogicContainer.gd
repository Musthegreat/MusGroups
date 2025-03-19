extends HBoxContainer

@export var delete: Button
@export var option: OptionButton

func _ready() -> void:
	delete.pressed.connect(pressedDelete)
	
func pressedDelete() -> void:
	queue_free()
