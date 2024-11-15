extends Node2D

@export var camera: Camera2D
@export var cameraSpeed: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Scrollup"):
		camera.set_zoom(lerp(camera.get_zoom(),camera.get_zoom()+Vector2(1,1), 1.2))
		camera.set_offset(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Scrolldown") and camera.get_zoom() > Vector2(1,1):
		camera.set_zoom(camera.get_zoom()-Vector2(1,1))
		camera.set_offset(get_global_mouse_position())
	
	if Input.get_axis("Up","Down") or Input.get_axis("Left","Right"):
		camera.set_offset(Vector2(camera.get_offset().x+(Input.get_axis("Left","Right")*cameraSpeed),camera.get_offset().y+(Input.get_axis("Up","Down")*cameraSpeed)))
