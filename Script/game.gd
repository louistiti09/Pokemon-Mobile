extends Node2D

var stats = null
var incomming_attacks = [null,null]
var against_bot = true
var Joueurs = ["Louistiti","BOT"]
var ClientPokemon = 0
var ClientDeck = [
	{
		"Name":"Bulbizarre",
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Precision":{"Modif":0},
			"Esquive":{"Modif":0},
			"Attaque":{"Modif":0,"IV":0,"EV":0},
			"Defense":{"Modif":0,"IV":0,"EV":0},
			"AttaqueSpe":{"Modif":0,"IV":0,"EV":0},
			"DefenseSpe":{"Modif":0,"IV":0,"EV":0},
			"Vitesse":{"Modif":0,"IV":0,"EV":0}},
		"LvL":100,
		"Nature":"Discret",
		"Damages":0,
		"Shiny":"s",
		"Attacks":[
			{"Name":"Charge","PP":35},
			{"Name":"Rugissement","PP":40},
			{"Name":"Lutte","PP":10}]
	}
]
var OppPokemon = 0
var OppDeck = [
	{
		"Name":"Bulbizarre",
		"Stats":{
			"PV":{"IV":0,"EV":0},
			"Precision":{"Modif":0},
			"Esquive":{"Modif":0},
			"Attaque":{"Modif":0,"IV":0,"EV":0},
			"Defense":{"Modif":0,"IV":0,"EV":0},
			"AttaqueSpe":{"Modif":0,"IV":0,"EV":0},
			"DefenseSpe":{"Modif":0,"IV":0,"EV":0},
			"Vitesse":{"Modif":0,"IV":0,"EV":0}},
		"LvL":100,
		"Nature":"Modeste",
		"Damages":0,
		"Shiny":"s",
		"Attacks":[
			{"Name":"Charge","PP":35},
			{"Name":"Rugissement","PP":40},
			{"Name":"Lutte","PP":10}]
	}
]

@onready var ClientNodes = {
	"Sprite": $Sprites/ClientPkmn,
	"Name": $UI/Pokemons_UI/Client/Margin/VBox/Label,
	"LvL": $UI/Pokemons_UI/Client/Margin/VBox/Label/LvL,
	"HealthBar": $UI/Pokemons_UI/Client/Margin/VBox/Bar,
	"HealthLabel": $UI/Pokemons_UI/Client/Margin/VBox/Bar/Label,
	"Block": $UI/Pokemons_UI/Client,
	"Pokeball": $Sprites/ClientBall,
	"BasePos": $Sprites/ClientPkmn.position
}
@onready var OppNodes = {
	"Sprite": $Sprites/OppPkmn,
	"Name": $UI/Pokemons_UI/Opp/Margin/VBox/Label,
	"LvL": $UI/Pokemons_UI/Opp/Margin/VBox/Label/LvL,
	"HealthBar": $UI/Pokemons_UI/Opp/Margin/VBox/Bar,
	"HealthLabel": $UI/Pokemons_UI/Opp/Margin/VBox/Bar/Label,
	"Block": $UI/Pokemons_UI/Opp,
	"Pokeball": $Sprites/OppBall,
	"BasePos": $Sprites/OppPkmn.position
}
@onready var TutoUI = {
	"Label": $UI/Tutorial_UI/Label,
	"Block": $UI/Tutorial_UI
}
@onready var MainUI = {
	"MainMenu": $UI/Main_UI/Basis_UI,
	"AtkMenu": $UI/Main_UI/Attack_UI,
	"PkmMenu": $UI/Main_UI/Pokemon_UI,
}
@onready var ActionUI = {
	"Label": $UI/Action_UI/Margin/Label,
	"Block": $UI/Action_UI
}
@onready var Audios = {
	"Button" : $Audios/Button,
	"Attack" : $Audios/Attack,
	"SFX" : $Audios/SFX
}

func load_stats():
	var file_path = "res://Script/stats.gd"
	if FileAccess.file_exists(file_path):
		stats = load(file_path)

func get_pokemon_img(face : String,pkm_name : String, shiny : String):
	var pokedex = stats.POKEMONS.get(pkm_name).get("Pokedex")
	return "res://Textures/Pokemons/%s/%s/f1/%s.png" % [face,shiny,pokedex]

func stat(pkm : Dictionary, Stat : String):
	if Stat == "PV" :
		var Base = stats.POKEMONS.get(pkm.Name).get(Stat)
		var IV = pkm.Stats.PV.IV
		var EV = int(pkm.Stats.PV.EV/4)
		var FinalStat = round((((2*Base+IV+EV)*pkm.LvL)/100.0)+pkm.LvL+10)
		return FinalStat
	elif Stat == "Precision" || Stat == "Esquive" :
		var Modif = pkm.Stats[Stat].Modif
		return round(100*stats.MODIF_PRE[Modif])
	else :
		var Modif = pkm.Stats[Stat].Modif
		var Base = stats.POKEMONS.get(pkm.Name).get(Stat)
		var IV = pkm.Stats[Stat].IV
		var EV = int(pkm.Stats[Stat].EV/4)
		var Nat = 1
		if stats.NATURE[pkm.Nature][0] == Stat:
			Nat = 1.1
		elif stats.NATURE[pkm.Nature][1] == Stat:
			Nat = 0.9
		return ((round(((2*Base+IV+EV)*pkm.LvL)/100.0)+5)*Nat)*stats.MODIF_STAT[Modif]

func reset_game():
	MainUI.MainMenu.visible = false
	MainUI.AtkMenu.visible = false
	MainUI.PkmMenu.visible = false
	MainUI.MainMenu.find_child("Attack").disabled = false
	MainUI.MainMenu.find_child("Pokemon").disabled = false
	MainUI.MainMenu.find_child("Objet").disabled = false
	TutoUI.Block.visible = false
	ActionUI.Block.visible = false
	ClientNodes.Sprite.texture = null
	ClientNodes.Block.visible = false
	ClientNodes.Pokeball.visible = false
	OppNodes.Sprite.texture = null
	OppNodes.Block.visible = false
	OppNodes.Pokeball.visible = false

func refresh_game():
	if len(ClientDeck) > 0:
		var pkm = ClientDeck[ClientPokemon]
		var MaxHealth = stat(pkm,"PV")
		var Health = MaxHealth - pkm.Damages
		ClientNodes.Name.text = "%s" % pkm.Name
		ClientNodes.LvL.text = "Lv.%s" % pkm.LvL
		ClientNodes.HealthBar.max_value = MaxHealth
		ClientNodes.HealthBar.value = Health
		ClientNodes.HealthLabel.text = "%s / %s" % [Health,MaxHealth]
		ClientNodes.Block.visible = true
		ClientNodes.Sprite.texture = load(get_pokemon_img("Back",pkm.Name,pkm.Shiny))
	if len(OppDeck) > 0:
		var pkm = OppDeck[OppPokemon]
		var MaxHealth = stat(pkm,"PV")
		var Health = MaxHealth - pkm.Damages
		OppNodes.Name.text = "%s" % pkm.Name
		OppNodes.LvL.text = "Lv.%s" % pkm.LvL
		OppNodes.HealthBar.max_value = MaxHealth
		OppNodes.HealthBar.value = Health
		OppNodes.HealthLabel.text = "%s / %s" % [Health,MaxHealth]
		OppNodes.Block.visible = true
		OppNodes.Sprite.texture = load(get_pokemon_img("Front",pkm.Name,pkm.Shiny))

func precision_check(pkm : Dictionary,target : Dictionary,atk : String):
	if atk == "Lutte":
		return true
	else:
		var Pre = stats.ATTACKS[atk].Precision
		var PreA2 = stat(pkm,"Precision")
		var EsqB = stat(target,"Esquive")
		return randi_range(0,100) <= Pre * PreA2 / EsqB

func attaque_statut(pkm : Dictionary,target : Dictionary,atk : String,plr : int):
	await get_tree().create_timer(2).timeout
	if atk == "Rugissement":
		if target.Stats.Attaque.Modif > -6 :
			target.Stats.Attaque.Modif -= 1
			Audios.SFX.stream = load("res://Sounds/SFX/Status/Stat Down.mp3")
			Audios.SFX.playing = true
			if plr == 1:
				await action_ui_writing("L'Attaque du %s ennemi baisse !" % [target.Name])
			else :
				await action_ui_writing("L'Attaque de %s baisse !" % [target.Name])
		else :
			await action_ui_writing("Mais rien ne se passe...")
	else : return
	await get_tree().create_timer(2).timeout

func crit_check(pkm : Dictionary,atk : String):
	var vitesse = stat(pkm,"Vitesse")
	return randi_range(0,255) <= vitesse*stats.ATTACKS[atk].Critique/2.0

func weakness_calculation(atk : String,target : Dictionary):
	var TypeAtk = stats.ATTACKS[atk].Type
	var TypeTarget1 = stats.POKEMONS[target.Name].Type1
	var TypeTarget2 = stats.POKEMONS[target.Name].Type2
	var R = 1.0
	if stats.TABLE_TYPE[TypeAtk].has(TypeTarget1):
		R *= stats.TABLE_TYPE[TypeAtk][TypeTarget1]
	if stats.TABLE_TYPE[TypeAtk].has(TypeTarget2):
		R *= stats.TABLE_TYPE[TypeAtk][TypeTarget2]
	if atk == "Lutte":
		if TypeTarget1 == "Roche" || TypeTarget1 == "Acier" || TypeTarget2 == "Roche" || TypeTarget2 == "Acier": R = 0
	return R

func damage_calculation(pkm : Dictionary,target : Dictionary,atk : String,crit : bool,weakness : float):
	var Att = 0
	var Def = 0
	if stats.ATTACKS[atk].Categorie == "Physique" :
		Att = stat(pkm,"Attaque")
		Def = stat(target,"Defense")
	elif stats.ATTACKS[atk].Categorie == "Special" : 
		Att = stat(pkm,"AttaqueSpe")
		Def = stat(target,"DefenseSpe")
	var CM = randf_range(0.85,1) * weakness
	var TypeAtk = stats.ATTACKS[atk].Type
	var TypePkm1 = stats.POKEMONS[pkm.Name].Type1
	var TypePkm2 = stats.POKEMONS[pkm.Name].Type2
	if TypeAtk == TypePkm1 || TypeAtk == TypePkm2:
		if atk != "Lutte":
			CM *= 1.5#----------------------------STAB
	var LvL = pkm.LvL
	if crit:
		CM *= (2*LvL+5)/(LvL+5)#------------------CRIT
	return round((((((LvL*0.4+2)*Att*stats.ATTACKS[atk].Puissance)/Def)/50)+2)*CM)

func action_ui_writing(text : String):
	var time = 0.02
	ActionUI.Label.text = ""
	for letter in text:
		ActionUI.Label.text += letter
		await get_tree().create_timer(time).timeout            #Time -> for one letter
		#await get_tree().create_timer(time/len(text)).timeout #Time -> total

func damage_animation(plr : int, damages : int, weak : int):
	var time = 1.0
	var divisions = 100.0
	var ui
	var pkm
	if weak == 1:
		Audios.SFX.stream = load("res://Sounds/SFX/Damages/Normal.mp3")
	elif weak < 1:
		Audios.SFX.stream = load("res://Sounds/SFX/Damages/Weak.mp3")
	else :
		Audios.SFX.stream = load("res://Sounds/SFX/Damages/Effective.mp3")
	Audios.SFX.playing = true
	if plr == 1:
		pkm = OppDeck[OppPokemon]
		ui = OppNodes
	else:
		pkm = ClientDeck[ClientPokemon]
		ui = ClientNodes
	var MaxHealth = stat(pkm,"PV")
	for i in range(1,divisions+1):
		ui.Sprite.visible = !floor(i%int(divisions/5)/10.0)#binary code
		var Health = MaxHealth - pkm.Damages
		Health -= round(damages*i/divisions)
		if Health < 0:
			Health = 0
		ui.HealthBar.value = Health
		ui.HealthLabel.text = "%s / %s" % [Health,MaxHealth]
		await get_tree().create_timer(time/divisions).timeout
	pkm.Damages += damages
	if pkm.Damages > MaxHealth:
		pkm.Damages = MaxHealth
	await get_tree().create_timer(0.2).timeout

func attack_animation(plr : int,atk : String):
	var pkm
	if plr == 1: pkm = ClientNodes.Sprite
	else : pkm = OppNodes.Sprite
	var s = 0
	if plr == 1: s = 1
	else : s = -1
	Audios.Attack.stream = load("res://Sounds/SFX/Attack/%s.mp3" % atk)
	Audios.Attack.playing = true
	await get_tree().create_timer(0.2).timeout
	if atk == "Lutte":
		pass
	elif atk == "Charge":
		var time = 0.1
		var divisions = 100.0
		for i in range(1,divisions+1):
			if i > divisions/2:
				pkm.offset.x -= 10/divisions*s
			else:
				pkm.offset.x += 10/divisions*s
			await get_tree().create_timer(time/divisions).timeout
		pkm.offset.x = 0

func attack_side_effect(pkm : Dictionary,target : Dictionary,atk : String,plr : int,bulk : Dictionary = {}):
	if atk == "Lutte":
		if plr == 1:
			damage_animation(2,round(stat(pkm,"PV")/4),1)#S'inflige lui-même la moitié de ses dégâts
			await action_ui_writing("%s se blesse dans son attaque !" % [target.Name])
		else :
			damage_animation(1,round(stat(pkm,"PV")/4),1)#S'inflige lui-même la moitié de ses dégâts
			await action_ui_writing("%s ennemi se blesse dans son attaque !" % [target.Name])
	else : return
	await get_tree().create_timer(2).timeout

func crit_animation():
	ActionUI.Label["theme_override_colors/font_color"] = Color8(255,0,0)
	await action_ui_writing("Coup Critique !")
	await get_tree().create_timer(2).timeout

func weakness_animation(weakness : int):
	if weakness >= 2 :
		await action_ui_writing("C'est super efficace !")
	elif weakness == 0 :
		await action_ui_writing("Ça ne l'affecte pas...")
	elif weakness <= 0.5 :
		await action_ui_writing("Ce n'est pas très efficace")
	await get_tree().create_timer(2).timeout

func pokemon_fainted(plr : int):
	if plr == 1:
		print("Client mort")
	else :
		print("Opp mort")

func attack(plr : int):
	var pkm
	var atk = incomming_attacks[plr-1]
	var target
	if plr==1:
		pkm = ClientDeck[ClientPokemon]
		target = OppDeck[OppPokemon]
		await action_ui_writing("%s lance %s !" % [pkm.Name,atk])
	else :
		pkm = OppDeck[OppPokemon]
		target = ClientDeck[ClientPokemon]
		await action_ui_writing("%s ennemi lance %s !" % [pkm.Name,atk])
	for a in pkm.Attacks:
		if a.Name == atk:
			a.PP -= 1
	ActionUI.Block.visible = true
	await get_tree().create_timer(1).timeout
	attack_animation(plr,atk)
	await get_tree().create_timer(0.5).timeout
	if precision_check(pkm,target,atk):
		if stats.ATTACKS[atk].Categorie == "Statut" :
			await attaque_statut(pkm,target,atk,plr)
		else:
			var crit = crit_check(pkm,atk)
			var weakness = weakness_calculation(atk,target)
			var damages = damage_calculation(pkm,target,atk,crit,weakness)
			await damage_animation(plr,damages,weakness)
			await attack_side_effect(pkm,target,atk,plr,
				{
					"Damages":damages
				})
			if crit == true:await crit_animation()
			ActionUI.Label["theme_override_colors/font_color"] = Color8(255,255,255)
			if weakness != 1 :await weakness_animation(weakness)
			ActionUI.Label.text = ""
	else :
		await action_ui_writing("Mais cela échoue !")
	await get_tree().create_timer(2.0).timeout
	if plr == 1:
		if ClientNodes.HealthBar.value == 0:
			await pokemon_fainted(1)
		if OppNodes.HealthBar.value == 0:
			await pokemon_fainted(2)
	else :
		if OppNodes.HealthBar.value == 0:
			await pokemon_fainted(2)
		if ClientNodes.HealthBar.value == 0:
			await pokemon_fainted(1)

func first_attackant(pkm1 : Dictionary,atk1 : Dictionary,pkm2 : Dictionary,atk2 : Dictionary):
	var prio1 = atk1.Priorite
	var prio2 = atk2.Priorite
	if prio1 == prio2:
		var vit1 = pkm1.Vitesse
		var vit2 = pkm2.Vitesse
		return vit1 > vit2
	else:
		return prio1 > prio2

func ia_attack_selection():
	var attack_list = OppDeck[OppPokemon].Attacks
	var random = randi_range(0,len(attack_list)-1)
	incomming_attacks[1] = attack_list[random].Name

func attack_phase():
	if against_bot == true:
		ia_attack_selection()
	reset_game()
	refresh_game()
	ActionUI.Label.text = ""
	ActionUI.Block.visible = true
	MainUI.MainMenu.visible = false
	var pkm1 = stats.POKEMONS[ClientDeck[ClientPokemon].Name]
	var atk1 = stats.ATTACKS[incomming_attacks[0]]
	var pkm2 = stats.POKEMONS[OppDeck[OppPokemon].Name]
	var atk2 = stats.ATTACKS[incomming_attacks[1]]
	var clientfirst = first_attackant(pkm1,atk1,pkm2,atk2)
	await get_tree().create_timer(1.0).timeout#Attendre 1 seconde
	if clientfirst:
		await attack(1)
		await attack(2)
	else :
		await attack(2)
		await attack(1)
	preparation_phase()

func enter_attack(a):
	Audios.Button.playing = true
	var a_name = ClientDeck[ClientPokemon].Attacks[a].Name
	incomming_attacks[0] = a_name
	if against_bot == true:
		attack_phase()

func change_pokemon(a):
	Audios.Button.playing = true

func pokemon_activation(plr : int, number : int):
	var pkm
	var pkm_name
	var ball
	var time = 0.7
	var divisions = 100.0
	if plr == 1:
		ClientPokemon = number
		pkm = ClientNodes.Sprite
		pkm_name = ClientDeck[ClientPokemon].Name
		pkm.texture = load(get_pokemon_img("Back",pkm_name,ClientDeck[ClientPokemon].Shiny))
		ball = ClientNodes.Pokeball
	else:
		OppPokemon = number
		pkm = OppNodes.Sprite
		pkm_name = OppDeck[OppPokemon].Name
		pkm.texture = load(get_pokemon_img("Front",pkm_name,OppDeck[OppPokemon].Shiny))
		ball = OppNodes.Pokeball
	ball.position = pkm.position+Vector2(0,30)
	ball.visible = true
	pkm.material.set_shader_parameter('avancement',0)
	ball.rotation = 0
	ball.frame_coords.y = 3
	await action_ui_writing("%s envoie %s !" % [Joueurs[plr-1],pkm_name])
	var open_timing = 0.0
	for i in range(1,divisions+1):
		ball.frame_coords.y = 3+floor(i/divisions*11)
		if ball.frame_coords.y==7:
			open_timing = i
		if ball.frame_coords.y>=7:
			pkm.material.set_shader_parameter('avancement', (i-open_timing)/(divisions-open_timing)*3.0)
		await get_tree().create_timer(time/divisions).timeout
	ball.visible = false
	Audios.SFX.stream = load("res://Sounds/SFX/Pokemon/%s.ogg" % pkm_name)
	Audios.SFX.playing = true
	await get_tree().create_timer(1.5).timeout

func preparation_phase():
	reset_game()
	refresh_game()
	MainUI.MainMenu.visible = true

func game():
	load_stats()
	reset_game()
	ActionUI.Label.text = ""
	ActionUI.Block.visible = true
	MainUI.MainMenu.visible = false
	ClientNodes.Pokeball.position = ClientNodes.Sprite.position+Vector2(0,30)+Vector2(0,240)
	ClientNodes.Pokeball.visible = true
	OppNodes.Pokeball.position = OppNodes.Sprite.position+Vector2(0,30)+Vector2(0,240)
	OppNodes.Pokeball.visible = true
	await pokemon_activation(2,0)
	await pokemon_activation(1,0)
	preparation_phase()

func _on_attack_pressed():
	Audios.Button.playing = true
	MainUI.MainMenu.find_child("Attack").disabled = true
	MainUI.MainMenu.find_child("Pokemon").disabled = true
	MainUI.MainMenu.find_child("Objet").disabled = true
	var VBox = MainUI.AtkMenu.find_child("Margin").find_child("HBox").find_child("Attacks").find_child("VBox")
	var attack_list = ClientDeck[ClientPokemon].Attacks
	for i in range(1,5):
		if i <= len(attack_list):
			var Name = attack_list[i-1].Name
			var PP = attack_list[i-1].PP
			var PPmax = stats.ATTACKS[Name].PP
			VBox.find_child("Attack%s" % i).text = "%s (%s/%s)" % [Name,PP,PPmax]
			var color8 = stats.TYPE_COLOR[stats.ATTACKS[Name].Type]
			VBox.find_child("Attack%s" % i)["theme_override_styles/normal"].bg_color = color8
			VBox.find_child("Attack%s" % i)["theme_override_styles/normal"].border_color = color8 - Color8(100,100,100,0)
			VBox.find_child("Attack%s" % i)["theme_override_styles/hover"].bg_color = color8 + Color8(50,50,50,0)
			VBox.find_child("Attack%s" % i)["theme_override_styles/hover"].border_color = color8 - Color8(100,100,100,0)
			VBox.find_child("Attack%s" % i)["theme_override_styles/pressed"].bg_color = color8 - Color8(100,100,100,0)
			VBox.find_child("Attack%s" % i)["theme_override_styles/disabled"].bg_color = color8 - Color8(100,100,100,0)
			VBox.find_child("Attack%s" % i).disabled = false
		else:
			VBox.find_child("Attack%s" % i).text = ""
			var color8 = stats.TYPE_COLOR["Normal"]
			VBox.find_child("Attack%s" % i)["theme_override_styles/disabled"].bg_color = color8 - Color8(100,100,100,0)
			VBox.find_child("Attack%s" % i).disabled = true
	MainUI.AtkMenu.visible = true
func _on_pokemon_pressed():
	Audios.Button.playing = true
	MainUI.MainMenu.find_child("Attack").disabled = true
	MainUI.MainMenu.find_child("Pokemon").disabled = true
	MainUI.MainMenu.find_child("Objet").disabled = true
	var VBox = MainUI.PkmMenu.find_child("Margin").find_child("HBox").find_child("Pokemons").find_child("VBox")
	for i in range(6):
		var button = VBox.find_child("L%s" % [floor(i/2.0)+1]).find_child(str(i+1))
		if i < len(ClientDeck):
			var Name = ClientDeck[i].Name
			var Shiny = ClientDeck[i].Shiny
			button.icon = load(get_pokemon_img("Front",Name,Shiny))
			button.disabled = i==ClientPokemon
		else :
			button.icon = null
			button.disabled = true
	MainUI.PkmMenu.visible = true
func _on_objet_pressed():
	Audios.Button.playing = true
func _on_back_pressed():
	Audios.Button.playing = true
	MainUI.MainMenu.find_child("Attack").disabled = false
	MainUI.MainMenu.find_child("Pokemon").disabled = false
	MainUI.MainMenu.find_child("Objet").disabled = false
	MainUI.AtkMenu.visible = false
	MainUI.PkmMenu.visible = false

func _on_attack_1_pressed():enter_attack(0)
func _on_attack_2_pressed():enter_attack(1)
func _on_attack_3_pressed():enter_attack(2)
func _on_attack_4_pressed():enter_attack(3)

func _on_pokemon_1_pressed():change_pokemon(0)
func _on_pokemon_2_pressed():change_pokemon(1)
func _on_pokemon_3_pressed():change_pokemon(2)
func _on_pokemon_4_pressed():change_pokemon(3)
func _on_pokemon_5_pressed():change_pokemon(4)
func _on_pokemon_6_pressed():change_pokemon(5)

func _ready():game()

var p_time = 0.0
func _process(delta):
	p_time += delta
	ClientNodes.Sprite.position.y = ClientNodes.BasePos.y + sin(p_time*7)
	OppNodes.Sprite.position.y = OppNodes.BasePos.y + cos(p_time*7)
