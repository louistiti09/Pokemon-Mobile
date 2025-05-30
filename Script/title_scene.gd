extends Node2D

func _ready():title_scene()
func title_scene():
	var pokemons = Stats.POKEMONS.keys()
	var random_pokemon = randi_range(1,pokemons.size())
	var battle_subtitle = pokemons[random_pokemon-1]
	var is_shiny = ""
	if randi_range(0,100) == 0: is_shiny = "s"
	else: is_shiny = "n"
	var path = "res://Textures/Pokemons/Front/%s/%s.png" % [is_shiny,random_pokemon]
	get_node('Pokemon1').texture = load(path)
	random_pokemon = randi_range(1,pokemons.size())
	battle_subtitle += " VS %s" % [pokemons[random_pokemon-1]]
	is_shiny = ""
	if randi_range(0,100) == 0: is_shiny = "s"
	else: is_shiny = "n"
	path = "res://Textures/Pokemons/Back/%s/%s.png" % [is_shiny,random_pokemon]
	get_node('Pokemon2').texture = load(path)
	$Subtitle.text = battle_subtitle
	$AnimationPlayer.play("titlescene")

func _on_click_pressed():
	$Start.playing = true
	$AnimationPlayer.play("start_game")
