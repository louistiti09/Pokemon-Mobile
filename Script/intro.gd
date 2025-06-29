extends Node2D

@onready var UI = {
	"MainLabel" : $Text/Label,
	"Skip" : $Button,
	"AvatarSelection" : {
		"Red" : $AvatarSelection/Red,
		"Leaf" : $AvatarSelection/Leaf,
		"Blue" : $AvatarSelection/Blue
	},
	"AvatarSelected" : $AvatarSelected,
	"PseudoSelected" : $PseudoSelected,
	"PokemonSelection" : {
		"Bulbizarre" : $"PokemonSelection/1",
		"Salameche" : $"PokemonSelection/2",
		"Carapuce" : $"PokemonSelection/3"
	},
	"PokemonSelected" : $PokemonSelected,
	"PokemonName" : $PokemonName,
}
@onready var Audios = {
	"Button" : $Audios/Button,
	"SFX" : $Audios/SFX,
	"BGM" : $Audios/BGM
}

var progression = 1    #text progression
var starters = ["Bulbizarre","Salamèche","Carapuce"]
var shinystarters = [false,false,false]

var avatar = null
var pseudo = null
var pokemon = null
var shiny = null

func _ready(): if get_parent().get_class() == "Window": intro()
func intro():
	print("Launching Introduction")
	UI.MainLabel.text = ""
	UI.PseudoSelected.text = ""
	$AnimationPlayer.play("intro_part_1")

func action_ui_writing(text : String):
	var time = 0.02
	UI.MainLabel.text = ""
	for letter in text:
		UI.MainLabel.text += letter
		await get_tree().create_timer(time).timeout

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro_part_1":
		progression = 1
		await action_ui_writing("Bienvenue dans l’univers fascinant des Pokémons !")
		UI.Skip.visible = true
	elif anim_name == "intro_part_3":
		progression = 4
		await action_ui_writing("C'est bien toi ?")
		$AnimationPlayer.play("intro_part_4")
	elif anim_name == "intro_part_7":
		Audios.SFX.stream = load("res://Sounds/SFX/Pokemon/%s.ogg" % pokemon)
		Audios.SFX.playing = true
		await action_ui_writing("Alors prépare-toi à plonger dans l'aventure en compagnie de %s !" % pokemon)
		progression = 7
		UI.Skip.visible = true
	elif anim_name == "intro_part_8":
		ending()

func _on_button_pressed():
	Audios.Button.playing = true
	if progression == 1:
		UI.Skip.visible = false
		progression = 2
		await action_ui_writing("Ce fangame a pour but de rassembler des dresseurs voulant collectionner ou combattre avec les merveilleuses créatures peuplant ce monde.")
		UI.Skip.visible = true
	elif progression == 2:
		UI.Skip.visible = false
		progression = 3
		await action_ui_writing("Je suis le Professeur Chen, et je serais là pour t’aider à débuter dans ta carrière de dresseur.")
		UI.Skip.visible = true
	elif progression == 3:
		UI.Skip.visible = false
		await action_ui_writing("Au fait, à quoi ressembles-tu ?")
		$AnimationPlayer.play("intro_part_2")
	elif progression == 7:
		$AnimationPlayer.play("intro_part_8")

func _on_red_pressed():avatar_chosen(UI.AvatarSelection.Red)
func _on_leaf_pressed():avatar_chosen(UI.AvatarSelection.Leaf)
func _on_blue_pressed():avatar_chosen(UI.AvatarSelection.Blue)
func avatar_chosen(button : Control):
	Audios.Button.playing = true
	var node2D = button.get_node("Node2D")
	avatar = node2D.frame
	UI.AvatarSelected.frame = avatar
	UI.AvatarSelected.global_position = node2D.global_position+Vector2(80,80)
	UI.AvatarSelected.scale = Vector2(2,2)
	node2D.visible = false
	UI.AvatarSelected.visible = true
	$AnimationPlayer.play("intro_part_3")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(UI.AvatarSelected,"position",Vector2(400,400),1)
	tween.tween_property(UI.AvatarSelected,"scale",Vector2(3,3),1)

func _on_oui_pressed():
	Audios.Button.playing = true
	if progression == 4:
		$AnimationPlayer.play_backwards("intro_part_4")
		await get_tree().create_timer(0.75).timeout
		await action_ui_writing("D'ailleurs, comment dois-je t'appeler ?")
		$AnimationPlayer.play("intro_part_5")
	elif progression == 5:
		$AnimationPlayer.play_backwards("intro_part_4")
		await get_tree().create_timer(0.75).timeout
		if UI.PseudoSelected.text != pseudo:
			UI.PseudoSelected.text = pseudo
			var i = 0
			for pkm in starters:
				i += 1
				var pokedex = Stats.POKEMONS.keys().find(pkm)+1
				var is_shiny
				if randi_range(0,512) == 0:
					is_shiny = "s"
					shinystarters[i-1] = true
				else: is_shiny = "n"
				var node = $PokemonSelection.get_node(str(i))
				node.get_node("TextureRect").texture = load("res://Textures/Pokemons/Front/%s/%s.png" % [is_shiny,pokedex])
				node.get_node("Label").text = pkm
			$AnimationPlayer.play("intro_part_6")
		await action_ui_writing("Très bien ! Il va maintenant falloir que tu choisisses ton premier nouvel ami.")
		UI.PokemonSelection.Bulbizarre.disabled = false
		UI.PokemonSelection.Salameche.disabled = false
		UI.PokemonSelection.Carapuce.disabled = false
	elif progression == 6:
		$AnimationPlayer.play_backwards("intro_part_4")
		await get_tree().create_timer(0.75).timeout
		var button = pokemon
		var i = button.name.to_int()-1
		pokemon = starters[i]
		shiny = shinystarters[i]
	
		var textrect = button.get_node("TextureRect")
		UI.PokemonSelected.texture = textrect.texture
		UI.PokemonSelected.global_position = textrect.global_position
		textrect.visible = false
		UI.PokemonSelected.visible = true
		
		var label = button.get_node("Label")
		UI.PokemonName.text = label.text
		UI.PokemonName.global_position = label.global_position
		UI.PokemonName["theme_override_colors/font_outline_color"] = label["theme_override_colors/font_outline_color"]
		label.visible = false
		UI.PokemonName.visible = true
		
		$AnimationPlayer.play("intro_part_7")
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(UI.PokemonSelected,"position",Vector2(245,380),1)
		tween.tween_property(UI.PokemonName,"position",Vector2(240,505),1)

func _on_non_pressed():
	Audios.Button.playing = true
	if progression == 4:
		UI.AvatarSelection.Red.get_node("Node2D").visible = true
		UI.AvatarSelection.Leaf.get_node("Node2D").visible = true
		UI.AvatarSelection.Blue.get_node("Node2D").visible = true
		$AnimationPlayer.play_backwards("intro_part_4")
		await get_tree().create_timer(0.75).timeout
		action_ui_writing("Au fait, à quoi ressembles-tu ?")
		$AnimationPlayer.play("intro_part_2")
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(UI.AvatarSelected,"position",Vector2(800,0),0.2)
	elif progression == 5:
		progression = 4
		_on_oui_pressed()
	elif progression == 6:
		progression = 5
		_on_oui_pressed()

func _on_pseudo_submitted(new_text):
	Audios.Button.playing = true
	pseudo = new_text
	$AnimationPlayer.play_backwards("intro_part_5")
	await get_tree().create_timer(1.01).timeout
	progression = 5
	await action_ui_writing("%s, c'est bien ton nom ?" % pseudo)
	$AnimationPlayer.play("intro_part_4")

func _on_bulbizarre_pressed():pokemon_chosen(UI.PokemonSelection.Bulbizarre)
func _on_salamèche_pressed():pokemon_chosen(UI.PokemonSelection.Salameche)
func _on_carapuce_pressed():pokemon_chosen(UI.PokemonSelection.Carapuce)
func pokemon_chosen(button : Control):
	Audios.Button.playing = true
	pokemon = button
	progression = 6
	await action_ui_writing("Es-tu sûr de vouloir choisir %s ?" % starters[button.name.to_int()-1])
	$AnimationPlayer.play("intro_part_4")

func ending():
	var data = SaveManager.load_data()
	data.Pseudo = pseudo
	data.Avatar = avatar
	var all_natures = Stats.NATURE.keys()
	var random_nature = all_natures[randi_range(0,all_natures.size()-1)]
	var is_shiny = ""
	if shiny: is_shiny = "s"
	else: is_shiny = "n"
	var random_stats = {
		"PV":{"IV":randi_range(0,31),"EV":0},
		"Attaque":{"IV":randi_range(0,31),"EV":0},
		"Defense":{"IV":randi_range(0,31),"EV":0},
		"AttaqueSpe":{"IV":randi_range(0,31),"EV":0},
		"DefenseSpe":{"IV":randi_range(0,31),"EV":0},
		"Vitesse":{"IV":randi_range(0,31),"EV":0}}
	var all_moves = Stats.POKEMONS[pokemon].NativeAttacks
	var learnable_moves = []
	for move in all_moves: if move.LvL<=5: learnable_moves.append(move.Attack)
	var random_moveset = []
	for _i2 in range(mini(4,learnable_moves.size())):
		var new_move = learnable_moves[randi_range(0,learnable_moves.size()-1)]
		random_moveset.append({"Name":new_move})
		learnable_moves.erase(new_move)
	var new_pkm = {
		"Name":pokemon,
		"Nickname":null,
		"Stats":random_stats,
		"EXP":0,
		"LvL":5,
		"Nature":random_nature,
		"Shiny":is_shiny,
		"Attacks":random_moveset,
	}
	data.Pokemons.append(new_pkm)
	data.Partenaire = new_pkm
	data.Teams[data.ActiveTeam].Team.append(new_pkm)
	SaveManager.save_data(data)
	SceneManager.change_scene(self,"menu")
