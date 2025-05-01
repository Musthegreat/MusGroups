extends Control

var t = group.loadGroup(MusGroups.selectedGroup, MusGroups.identifier)
var groupInstances: Array

func _ready() -> void:
	%timerToggle.toggled.connect(toggled)
	%seconds.value_changed.connect(secondChanged)
	%minutes.value_changed.connect(minuteChanged)
	%hours.value_changed.connect(hourChanged)
	%days.value_changed.connect(dayChanged)
	
	t.timerStepped.connect(update)
	setup()

func setup() -> void:
	%seconds.set_value_no_signal(float(t.Seconds))
	%minutes.set_value_no_signal(float(t.Minutes))
	%hours.set_value_no_signal(float(t.Hours))
	%days.set_value_no_signal(float(t.Days))
	%timerToggle.set_pressed(t.toggled)

func update() -> void:
	%timeTillUpdate.set_text("Time until the timer runs is " + var_to_str(round(t.currentTime/86400)) + " days, " + var_to_str(round(t.currentTime/3600)) + " hours, " + var_to_str(round(t.currentTime/60)) + " minutes and total: " + var_to_str(t.currentTime) + " seconds")

func toggled(toggle) -> void:
	if toggle == true:
		t.toggled = true
		save()
	else:
		t.toggled = false
		save()

func secondChanged(value):
	t.Seconds = int(value)
	t.currentTime = t.Seconds + (t.Minutes * 60) + (t.Hours * 3600) + (t.Days * 86400)
	save()

func minuteChanged(value):
	t.Minutes = int(value)
	t.currentTime = t.Seconds + (t.Minutes * 60) + (t.Hours * 3600) + (t.Days * 86400)
	save()

func hourChanged(value):
	t.Hours = int(value)
	t.currentTime = t.Seconds + (t.Minutes * 60) + (t.Hours * 3600) + (t.Days * 86400)
	save()

func dayChanged(value):
	t.Days = int(value)
	t.currentTime = t.Seconds + (t.Minutes * 60) + (t.Hours * 3600) + (t.Days * 86400)
	save()

func save() -> void:
	t.save(MusGroups.identifier)
