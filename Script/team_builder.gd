extends Node2D

var TeamName
var Team = []
var Pokemons = []
var CurrentPkm = -1
var EditMode = false

@onready var MainMenu = {
	"Label" : $MainMenu/Team_Name/Label,
	"Team" : $MainMenu/VBox
}
@onready var PkmMenu = {
	"Name" : $PkmMenu/Panel/Label,
	"LvL" : $PkmMenu/Panel/Label/Lv,
	"Image" : $PkmMenu/Panel/TextureRect,
	"Types" : $PkmMenu/Panel/Types,
	"Block" : $PkmMenu/Panel,
	"Moves" : $PkmMenu/Panel/Moves,
	"Stats" : $PkmMenu/Panel/Stats,
	"EV_IV" : $PkmMenu/Panel/EV_IV,
	"EXP" : $PkmMenu/Panel/EXP,
	"AtkInfo" : $PkmMenu/Panel/AtkInfo
}
@onready var SamplePokemonButton = $Sample
@onready var SampleAddPokemonButton = $AddPkmSample

#									-----MAIN-----
func team_builder(team_number : int):
	var data = SaveManager.load_data()
	Team = data.Teams[team_number].Team
	TeamName = data.Teams[team_number].Name
	EditMode = false
	refresh_team()
func _ready(): team_builder(0)


#									-----NODES-----
func create_atk_node(atk : String):
	var node_atk = SamplePokemonButton.get_node("AtkSample").duplicate()
	var node_atk_bg = node_atk["theme_override_styles/panel"].duplicate()
	node_atk["theme_override_styles/panel"] = node_atk_bg
	node_atk.get_node("Label").text = atk
	node_atk_bg.bg_color = Stats.TYPE_COLOR[Stats.ATTACKS[atk].Type]
	node_atk.visible = true
	return node_atk

func create_pkm_button(pkm : Dictionary):
	var node = SamplePokemonButton.duplicate()
	var bg_material = SamplePokemonButton.material.duplicate()
	node.material = bg_material
	var pokedex = Stats.POKEMONS.keys().find(pkm.Name)+1
	var type1 = Stats.POKEMONS[pkm.Name].Type1
	var type2 = Stats.POKEMONS[pkm.Name].Type2
	node.get_node("TextureRect").texture = load("res://Textures/Pokemons/Front/%s/%s.png" % [pkm.Shiny,pokedex])
	bg_material.set_shader_parameter("color1",Stats.TYPE_COLOR[type1])
	if type2 != null : bg_material.set_shader_parameter("color2",Stats.TYPE_COLOR[type2]-Color8(40,40,40))
	else : bg_material.set_shader_parameter("color2",Stats.TYPE_COLOR[type1]-Color8(40,40,40))
	node.get_node("Label").text = "%s" % pkm.Name
	if pkm.Shiny == 's': node.get_node("Label").text += "☆"
	node.get_node("Label").text += "\nLv.%s" % pkm.LvL
	for atk in pkm.Attacks:
		var node_atk = create_atk_node(atk.Name)
		if node.get_node("Left").get_child_count() < 2: node.get_node("Left").add_child(node_atk)
		else: node.get_node("Right").add_child(node_atk)
	node.disabled = false
	node.visible = true
	return node

func refresh_team():
	EditMode = false
	MainMenu.Label.text = TeamName
	for child in MainMenu.Team.get_children(): MainMenu.Team.remove_child(child)
	for pkm in Team:
		var node : Button = create_pkm_button(pkm)
		MainMenu.Team.add_child(node)
		node.connect("pressed",func():on_pkm_pressed(Team.find(pkm)))
	if Team.size()<6:
		var node : Button = SampleAddPokemonButton.duplicate()
		MainMenu.Team.add_child(node)
		node.connect("pressed",func():add_pokemon())
		node.visible = true


#									-----BUTTONS-----
func add_pokemon():
	print("add_pokemon")

func on_pkm_pressed(ip : int):
	CurrentPkm = ip
	var pkm = Team[CurrentPkm]
	$AnimationPlayer.play("to_pokemon")

	#Nom / LvL
	PkmMenu.Name.text = pkm.Name
	if pkm.Shiny == 's': PkmMenu.Name.text += " ☆"
	if pkm.Nickname != null: PkmMenu.Name.text += " (%s)" % pkm.Nickname
	PkmMenu.LvL.text = "Lv.%s" % pkm.LvL
	var pokedex = Stats.POKEMONS.keys().find(pkm.Name)+1
	PkmMenu.Image.texture = load("res://Textures/Pokemons/Front/%s/%s.png" % [pkm.Shiny,pokedex])
	
	#Types
	var Type1 = Stats.POKEMONS[pkm.Name].Type1
	var Type2 = Stats.POKEMONS[pkm.Name].Type2
	PkmMenu.Types.get_node("Type1").texture = load("res://Textures/Types/Expanded/%s.png" % Type1)
	PkmMenu.Block.material.set_shader_parameter("color1",Stats.TYPE_COLOR[Type1])
	if Type2 != null:
		PkmMenu.Types.get_node("Type2").texture = load("res://Textures/Types/Expanded/%s.png" % Type2)
		PkmMenu.Block.material.set_shader_parameter("color2",Stats.TYPE_COLOR[Type2]-Color8(40,40,40))
		PkmMenu.Types.get_node("Separator").visible = true
	else:
		PkmMenu.Types.get_node("Type2").texture = null
		PkmMenu.Block.material.set_shader_parameter("color2",Stats.TYPE_COLOR[Type1]-Color8(40,40,40))
		PkmMenu.Types.get_node("Separator").visible = false
	
	#Graph Stats
	var i = 0
	for z in pkm.Stats:
		#Radio
		var value = Stats.POKEMONS[pkm.Name][z]
		var ratio = value/255.0*PkmMenu.Stats.get_node("MAX").polygon[i]
		PkmMenu.Stats.get_node("PKM").polygon[i] = ratio
		PkmMenu.Stats.get_node("Label%s" % z)["theme_override_colors/font_color"] = Color(1,1,1,1)
		i += 1
		#EV / IV
		PkmMenu.EV_IV.get_node("EV/%s" % z).value = pkm.Stats[z].EV
		PkmMenu.EV_IV.get_node("IV/%s" % z).value = pkm.Stats[z].IV
	
	#EXP
	var maxEXP = Stats.max_exp_calculation(pkm,pkm.LvL+1)
	PkmMenu.EXP.max_value = maxEXP
	PkmMenu.EXP.value = pkm.EXP
	PkmMenu.EXP.get_node("Label").text = "%s/%s" % [pkm.EXP,maxEXP]
	
	#Nature
	var nature_boost = Stats.NATURE[pkm.Nature]
	PkmMenu.Stats.get_node("Nature").text = "Nature : %s" % pkm.Nature
	if nature_boost != ["",""]:
		PkmMenu.Stats.get_node("Label%s" % nature_boost[0])["theme_override_colors/font_color"] = Color(1,0,0,1)
		PkmMenu.Stats.get_node("Label%s" % nature_boost[1])["theme_override_colors/font_color"] = Color(0,1,1,1)
	
	#Moves
	for child in PkmMenu.Moves.get_children(): PkmMenu.Moves.remove_child(child)
	for atk in pkm.Attacks:
		var node = create_atk_node(atk.Name)
		PkmMenu.Moves.add_child(node)
		node.connect("mouse_entered",func():on_atk_hover(atk.Name))
	on_atk_hover(pkm.Attacks[0].Name)

func on_atk_hover(atk_name : String):
	var atk = Stats.ATTACKS[atk_name]
	PkmMenu.AtkInfo.get_node("AtkName").text = atk_name
	PkmMenu.AtkInfo.get_node("Categorie").texture = load("res://Textures/CategorieCapa/%s.png" % atk.Categorie)
	PkmMenu.AtkInfo.get_node("Type").texture = load("res://Textures/Types/Expanded/%s.png" % atk.Type)
	var pui = atk.Puissance
	if pui == null: pui = " /"
	PkmMenu.AtkInfo.get_node("Pui").text = "Pui : %s" % pui
	var pre = atk.Precision
	if pre == null: pre = " /"
	PkmMenu.AtkInfo.get_node("Pre").text = "Pre : %s" % pre
	PkmMenu.AtkInfo.get_node("PP").text = "PP : %s" % atk.PP
	PkmMenu.AtkInfo.get_node("Desc").text = atk.Description

func move_pkm(i):
	CurrentPkm = i
	for node in MainMenu.Team.get_children():
		node.get_node("EditPanel/AcceptMove").visible = true
		node.get_node("EditPanel/Move").visible = false
		node.get_node("EditPanel/Remove").disabled = true

func accept_move_pkm(to):
	var from = Team[CurrentPkm]
	Team[CurrentPkm] = Team[to]
	Team[to] = from
	refresh_team()

func remove_pkm(i):
	Pokemons.append(Team[i])
	Team.remove_at(i)
	refresh_team()

func _on_quitter_pressed(): $AnimationPlayer.play_backwards("to_pokemon")

func _on_edit_pressed():
	if !EditMode:
		EditMode = true
		for button in MainMenu.Team.get_children():
			MainMenu.Team.remove_child(button)
		for pkm in Team:
			var node : Button = create_pkm_button(pkm)
			node.mouse_default_cursor_shape = Control.CURSOR_ARROW
			node.disabled = true
			node.get_node("EditPanel").visible = true
			MainMenu.Team.add_child(node)
			node.get_node("EditPanel/Move").connect("pressed",func():move_pkm(Team.find(pkm)))
			node.get_node("EditPanel/AcceptMove").connect("pressed",func():accept_move_pkm(Team.find(pkm)))
			node.get_node("EditPanel/Remove").connect("pressed",func():remove_pkm(Team.find(pkm)))
	else: refresh_team()

func _on_label_text_changed(new_text): TeamName = new_text
