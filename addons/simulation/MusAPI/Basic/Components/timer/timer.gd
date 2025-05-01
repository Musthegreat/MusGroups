extends group
class_name timer
signal timerStepped

@export var Days: int
@export var Hours: int
@export var Minutes: int
@export var Seconds: int = 1

@export var currentTime: int = 1

@export var toggled: bool = false
@export var groupToRun: String = ""

func _init() -> void:
	Menu.append(preload("res://addons/simulation/MusAPI/Basic/Components/timer/timerInspector.tscn"))
