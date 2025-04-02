extends Node2D

var TeamName = "Equipe"
var Team = [
	{"Name":"Tygnon",
		"Nickname":null,
		"Stats":{
			"PV":{"IV":31,"EV":0},
			"Attaque":{"IV":31,"EV":252},
			"Defense":{"IV":31,"EV":128},
			"AttaqueSpe":{"IV":31,"EV":0},
			"DefenseSpe":{"IV":31,"EV":128},
			"Vitesse":{"IV":31,"EV":2}},
		"EXP":0,
		"LvL":50,
		"Nature":"Mauvais",
		"Damages":0,
		"Shiny":"s",
		"Attacks":[
			{"Name":"Riposte","PP":20},
			{"Name":"Poing de Feu","PP":15},
			{"Name":"Poinglace","PP":15},
			{"Name":"Poing-Éclair","PP":15},
		],
		"Statut":[]},
	{"Name":"Alakazam",
		"Nickname":null,
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Attaque":{"IV":0,"EV":0},
			"Defense":{"IV":0,"EV":0},
			"AttaqueSpe":{"IV":0,"EV":0},
			"DefenseSpe":{"IV":0,"EV":0},
			"Vitesse":{"IV":0,"EV":0}},
		"EXP":0,
		"LvL":50,
		"Nature":"Relax",
		"Damages":0,
		"Shiny":"s",
		"Attacks":[
			{"Name":"Télékinésie","PP":15},
			{"Name":"Soin","PP":5},
			{"Name":"Protection","PP":20},
			{"Name":"Psyko","PP":10}
		],
		"Statut":[]},
	{"Name":"Mélodelfe",
		"Nickname":null,
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Attaque":{"IV":0,"EV":0},
			"Defense":{"IV":0,"EV":0},
			"AttaqueSpe":{"IV":0,"EV":0},
			"DefenseSpe":{"IV":0,"EV":0},
			"Vitesse":{"IV":0,"EV":0}},
		"EXP":0,
		"LvL":50,
		"Nature":"Jovial",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Métronome","PP":10},
			{"Name":"Lilliput","PP":10},
			{"Name":"Boul'Armure","PP":40},
			{"Name":"Torgnoles","PP":10}],
		"Statut":[]},
	{"Name":"Nidoking",
		"Nickname":null,
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Attaque":{"IV":0,"EV":0},
			"Defense":{"IV":0,"EV":0},
			"AttaqueSpe":{"IV":0,"EV":0},
			"DefenseSpe":{"IV":0,"EV":0},
			"Vitesse":{"IV":0,"EV":0}},
		"EXP":0,
		"LvL":50,
		"Nature":"Gentil",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Dard-Venin","PP":20},
			{"Name":"Koud'Korne","PP":25},
			{"Name":"Empal'Korne","PP":5},
			{"Name":"Mania","PP":10}
		],
		"Statut":[]},
	{"Name":"Pikachu",
		"Nickname":null,
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Attaque":{"IV":0,"EV":0},
			"Defense":{"IV":0,"EV":0},
			"AttaqueSpe":{"IV":0,"EV":0},
			"DefenseSpe":{"IV":0,"EV":0},
			"Vitesse":{"IV":0,"EV":0}},
		"EXP":0,
		"LvL":50,
		"Nature":"Brave",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Tonnerre","PP":15},
			{"Name":"Reflet","PP":15},
			{"Name":"Mur Lumière","PP":30},
			{"Name":"Cage-Éclair","PP":20}
		],
		"Statut":[]},
	{"Name":"Rattatac",
		"Nickname":null,
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Attaque":{"IV":0,"EV":0},
			"Defense":{"IV":0,"EV":0},
			"AttaqueSpe":{"IV":0,"EV":0},
			"DefenseSpe":{"IV":0,"EV":0},
			"Vitesse":{"IV":0,"EV":0}},
		"EXP":0,
		"LvL":50,
		"Nature":"Rigide",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Croc Fatal","PP":10},
			{"Name":"Mimi-Queue","PP":30},
			{"Name":"Vive-Attaque","PP":30},
			{"Name":"Croc de Mort","PP":15}
		],
		"Statut":[]},
]

var stats = null
func load_stats():
	var file_path = "res://Script/stats.gd"
	if FileAccess.file_exists(file_path):
		stats = load(file_path)

func max_exp_calculation(pkm : Dictionary, next_lvl : int):
	var curb = stats.POKEMONS[pkm.Name].Courbe_EXP
	if curb == "Rapide":
		return 0.8*next_lvl**3
	elif curb == "Moyenne":
		return next_lvl**3
	elif curb == "Parabolique":
		return 1.2*next_lvl**3 - 15*next_lvl**2 + 100*next_lvl - 140
	elif curb == "Lente":
		return 1.25*next_lvl**3

func _ready():
	load_stats()
	var i = 0
	$MainMenu/Team_Name/Label.text = TeamName
	for pkm in Team:
		i += 1
		var node = $MainMenu/VBox.find_child("Pkm%s" % i)
		var pokedex = stats.POKEMONS.keys().find(pkm.Name)+1
		node.find_child("TextureRect").texture = load("res://Textures/Pokemons/Front/%s/%s.png" % [pkm.Shiny,pokedex])
		var type1 = stats.POKEMONS[pkm.Name].Type1
		var type2 = stats.POKEMONS[pkm.Name].Type2
		node.material.set_shader_parameter("color1",stats.TYPE_COLOR[type1])
		if type2 != null : node.material.set_shader_parameter("color2",stats.TYPE_COLOR[type2]-Color8(40,40,40))
		else : node.material.set_shader_parameter("color2",stats.TYPE_COLOR[type1]-Color8(40,40,40))
		node.find_child("Label").text = "%s" % pkm.Name
		if pkm.Shiny == 's': node.find_child("Label").text += "☆"
		if pkm.Nickname != null: node.find_child("Label").text += " (%s)" % pkm.Nickname
		node.find_child("Label").text += "\nLv.%s" % pkm.LvL
		var i2 = 0
		for atk in pkm.Attacks:
			i2 += 1
			var node_atk
			if i2 <= 2: node_atk = node.find_child("Left").find_child("Atk%s" % i2)
			else: node_atk = node.find_child("Right").find_child("Atk%s" % i2)
			node_atk.find_child("Label").text = atk.Name
			node_atk["theme_override_styles/panel"].border_width_left = 1
			node_atk["theme_override_styles/panel"].border_width_top = 1
			node_atk["theme_override_styles/panel"].border_width_right = 1
			node_atk["theme_override_styles/panel"].border_width_bottom = 1
			node_atk["theme_override_styles/panel"].bg_color = stats.TYPE_COLOR[stats.ATTACKS[atk.Name].Type]
		node.disabled = false

func on_pkm_pressed(n : int):
	$AnimationPlayer.play("to_pokemon")
	var pkm = Team[n-1]
	
	#Nom / LvL
	$PkmMenu/Panel/Label.text = pkm.Name
	if pkm.Shiny == 's': $PkmMenu/Panel/Label.text += " ☆"
	$PkmMenu/Panel/Label/Lv.text = "Lv.%s" % pkm.LvL
	var pokedex = stats.POKEMONS.keys().find(pkm.Name)+1
	$PkmMenu/Panel/TextureRect.texture = load("res://Textures/Pokemons/Front/%s/%s.png" % [pkm.Shiny,pokedex])
	
	#Types
	var Type1 = stats.POKEMONS[pkm.Name].Type1
	var Type2 = stats.POKEMONS[pkm.Name].Type2
	$PkmMenu/Panel/Types/Type1.texture = load("res://Textures/Types/Expanded/%s.png" % Type1)
	$PkmMenu/Panel.material.set_shader_parameter("color1",stats.TYPE_COLOR[Type1])
	if Type2 != null:
		$PkmMenu/Panel/Types/Type2.texture = load("res://Textures/Types/Expanded/%s.png" % Type2)
		$PkmMenu/Panel.material.set_shader_parameter("color2",stats.TYPE_COLOR[Type2]-Color8(40,40,40))
		$PkmMenu/Panel/Types/Label.visible = true
	else:
		$PkmMenu/Panel/Types/Type2.texture = null
		$PkmMenu/Panel.material.set_shader_parameter("color2",stats.TYPE_COLOR[Type1]-Color8(40,40,40))
		$PkmMenu/Panel/Types/Label.visible = false
	
	#Graph Stats
	var i = 0
	for z in pkm.Stats:
		#Radio
		var value = stats.POKEMONS[pkm.Name][z]
		var ratio = value/255.0*$PkmMenu/Panel/Stats/MAX.polygon[i]
		$PkmMenu/Panel/Stats/PKM.polygon[i] = ratio
		$PkmMenu/Panel/Stats.find_child("Label%s" % z)["theme_override_colors/font_color"] = Color(1,1,1,1)
		i += 1
		#EV / IV
		$PkmMenu/Panel/EV_IV/EV.find_child(z).value = pkm.Stats[z].EV
		$PkmMenu/Panel/EV_IV/IV.find_child(z).value = pkm.Stats[z].IV
	
	#EXP
	$PkmMenu/Panel/EXP.max_value = max_exp_calculation(pkm,pkm.LvL+1)
	$PkmMenu/Panel/EXP.value = pkm.EXP
	
	#Nature
	var nature_boost = stats.NATURE[pkm.Nature]
	$PkmMenu/Panel/Stats/Nature.text = "Nature : %s" % pkm.Nature
	if nature_boost != ["",""]:
		$PkmMenu/Panel/Stats.find_child("Label%s" % nature_boost[0])["theme_override_colors/font_color"] = Color(1,0,0,1)
		$PkmMenu/Panel/Stats.find_child("Label%s" % nature_boost[1])["theme_override_colors/font_color"] = Color(0,1,1,1)
	
	#Moves
	i = 0
	for atk in pkm.Attacks:
		i += 1
		var node_atk = $PkmMenu/Panel/Moves.find_child("Atk%s" % i)
		node_atk.find_child("Label").text = atk.Name
		node_atk["theme_override_styles/normal"].border_width_left = 1
		node_atk["theme_override_styles/normal"].border_width_top = 1
		node_atk["theme_override_styles/normal"].border_width_right = 1
		node_atk["theme_override_styles/normal"].border_width_bottom = 1
		node_atk["theme_override_styles/normal"].bg_color = stats.TYPE_COLOR[stats.ATTACKS[atk.Name].Type]

func _on_pkm_1_pressed():on_pkm_pressed(1)
func _on_pkm_2_pressed():on_pkm_pressed(2)
func _on_pkm_3_pressed():on_pkm_pressed(3)
func _on_pkm_4_pressed():on_pkm_pressed(4)
func _on_pkm_5_pressed():on_pkm_pressed(5)
func _on_pkm_6_pressed():on_pkm_pressed(6)

func _on_quitter_pressed(): $AnimationPlayer.play_backwards("to_pokemon")

func _on_echanger_pressed(): $AnimationPlayer.play("to_switch")
