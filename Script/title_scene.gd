extends Node2D

func _ready(): if get_parent().get_class() == "Window": title_scene()
func title_scene():
	var pokemons = Stats.POKEMONS.keys()
	var random_pokemon = randi_range(1,151)-1
	var battle_subtitle = pokemons[random_pokemon]
	var is_shiny = ""
	if randi_range(0,100) == 0: is_shiny = "s"
	else: is_shiny = "n"
	var path = "res://Textures/Pokemons/Front/%s/%s.png" % [is_shiny,random_pokemon+1]
	get_node('Pokemon1').texture = load(path)
	random_pokemon = randi_range(1,151)-1
	battle_subtitle += " VS %s" % [pokemons[random_pokemon]]
	is_shiny = ""
	if randi_range(0,100) == 0: is_shiny = "s"
	else: is_shiny = "n"
	path = "res://Textures/Pokemons/Back/%s/%s.png" % [is_shiny,random_pokemon+1]
	get_node('Pokemon2').texture = load(path)
	$Subtitle.text = battle_subtitle
	$AnimationPlayer.play("titlescene")

func _on_click_pressed():
	$AnimationPlayer.play("start_game")
	await get_tree().create_timer(2).timeout
	var data = SaveManager.load_data()
	if data.Pseudo == "": #Première connexion
		print("First Connection")
		print("-------------------------------------\n")
		SceneManager.change_scene(self,"intro",false)
	else: #Menu Principal
		print("Connected as %s" % data.Pseudo)
		print("-------------------------------------\n")
		SceneManager.change_scene(self,"menu")
