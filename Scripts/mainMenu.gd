extends Control

@export var gameName: LineEdit
@export var confirmNewGame: Button
@export var newGame: Button
@export var gameContainer: PackedScene

var gameList: PackedStringArray = MusGroups.loadGames()

func _ready() -> void:
	%newGame.pressed.connect(func(): %newGameMenu.set_visible(true))
	%confirmNewGame.pressed.connect(createGame)
	%refresh.pressed.connect(listGames)
	%ItemList.item_selected.connect(loadGame)
	
	MusGroups.identifier = MusGroups.generateWord("bus", 5)
	MusGroups.createDir()
	for i in gameList:
		%ItemList.add_item(i)

func loadGame(index) -> void:
	print(gameList[index])
	MusGroups.context = "server"
	MusGroups.game = gameList[index]
	get_tree().change_scene_to_packed(preload("res://Scenes/editor.tscn"))

func createGame() -> void:
	MusGroups.context = "server"
	MusGroups.newGame(%gameName.get_text())
	get_tree().change_scene_to_packed(preload("res://Scenes/editor.tscn"))
	
	var e = editors.new()
	e.editors.append(HAuth.product_user_id)
	e.save(MusGroups.identifier)

func listGames() -> void:
	for child in %gamesList.get_children():
		if child is not Button:
			child.queue_free()
	
	var results = await HLobbies.search_by_bucket_id_async("superbob")
		
	for lobby in results:
		var game = gameContainer.instantiate()
		%gamesList.add_child(game)
		
		game.update(lobby)
