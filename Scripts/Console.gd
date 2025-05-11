extends Node



func _ready() -> void:
	%Clear.pressed.connect(func(): %RichTextLabel.set_text(""))
