extends Control

@export var gameName: LineEdit
@export var confirmNewGame: Button
@export var center: CenterContainer
@export var newGame: Button
@export var gameContainer: PackedScene

func _ready() -> void:
	%newGame.pressed.connect(onNewGame)
	confirmNewGame.pressed.connect(makeConfirmNewGame)
	
	reloadList()
	

func reloadList() -> void:
	var list = await Firebase.Firestore.list("*")
	print(list)

func onNewGame() -> void:
	center.show()

func makeConfirmNewGame() -> void:
	if gameName.text != "":
		Singleton.game = gameName.text
		if Singleton.checkLogin():
			Singleton.collection = Firebase.Firestore.collection(gameName.text)
			Singleton.data = await Singleton.collection.add("data", {"groups": {}, "logic": {}, "templates": {}, "map": {}})
