extends Node2D
class_name rr_node

var Area: Area2D
var isHovering: bool = false
var isMoving: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_child_count():
		if get_child(i) is Area2D:
			Area = get_child(i)
			Area.mouse_entered.connect(on_mouse_entered)
			Area.mouse_exited.connect(on_mouse_exited)

func on_mouse_entered() -> void:
	isHovering = true

func on_mouse_exited() -> void:
	isHovering = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse1") and isHovering == true:
		isMoving = true
		
	if Input.is_action_just_released("Mouse1"):
		isMoving = false
		
	if isMoving:
		clickNDrag()

func clickNDrag() -> void:
	set_position(get_global_mouse_position())
