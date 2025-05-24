extends Control
signal startServer
signal startClient

@onready var UI: CanvasLayer = %UI
@onready var gameSpace: Node2D = %gameSpace

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	if MusGroups.context == "server":
		startServer.emit()
	elif MusGroups.context == "client":
		startClient.emit()
	
	MusGroups.createEnviorment()
	
	%Timer.timeout.connect(runTimer)
	MusGroups.sceneReferences["clientSpace"] = self
	
	%Timer.start(1)

func _process(delta: float) -> void:
	if !MusGroups.runQeueue.is_empty():
		var g = group.loadGroup(MusGroups.runQeueue[0], MusGroups.identifier)
		for i in g.Logics:
			var l: logic = logic.loadLogic(i, MusGroups.identifier)
			MusGroups.API["This"] = g
			var result = MusGroups.lua.do_string(l.unsplitCode, "", MusGroups.API)
			if result is LuaError:
				Print.printErr(MusGroups.sceneReferences["console"], result)
		MusGroups.runQeueue.remove_at(0)

func runTimer() -> void:
	#assemble a list of timers
	var timers: Array
	var dir: map = map.loadMap()
	for i in dir.data:
		var g = group.loadGroup(i, MusGroups.identifier)
		if g is timer:
			timers.append(g)
	
	#check if the timers are on and the internal timer reaches 0
	for t in timers:
		if t.toggled == true and t.currentTime <= 0:
			MusGroups.runQeueue.append(t.Instance)
			
			# reset the timer to the value given
			t.currentTime = t.Seconds + (t.Minutes * 60) + (t.Hours * 3600) + (t.Days * 86400)
		elif t.toggled == true: 
			# subtract one from the timer
			t.currentTime -= 1
			t.timerStepped.emit()
			t.save(MusGroups.identifier)
