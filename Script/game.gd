extends Node2D

#									-----GAME-----
var FPS = 30.0
var Joueurs = ["Louistiti","BOT"]
var against_wildpkm = false
var against_bot = true
var allow_death_switch = false
var decoration = "Dojo"
var ClientPokemon = 0
var ClientDeck = []
var ClientTeamID = 0
var OppPokemon = 0
var OppDeck = [
	{"Name":"Roucarnage",
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
		"Shiny":"n",
		"Attacks":[
			{"Name":"Cyclone"},
			{"Name":"Jet de Sable"},
			{"Name":"Mimique"},
			{"Name":"Cru-Aile"}
		],
		"Statut":[]},
	{"Name":"Tortank",
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
		"Nature":"Calme",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Coud'Krâne"},
			{"Name":"Mimi-Queue"},
			{"Name":"Hydrocanon"},
			{"Name":"Écume"}],
		"Statut":[]},
	{"Name":"Florizarre",
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
		"Nature":"Discret",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Poudre Dodo"},
			{"Name":"Croissance"},
			{"Name":"Tranch'Herbe"},
			{"Name":"Lance Soleil"}],
		"Statut":[]},
	{"Name":"Dracaufeu",
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
		"Shiny":"s",
		"Attacks":[
			{"Name":"Lance-Flammes"},
			{"Name":"Danse-Flammes"},
			{"Name":"Groz'Yeux"},
			{"Name":"Frénésie"}],
		"Statut":[]},
	{"Name":"Grolem",
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
		"Nature":"Docile",
		"Damages":0,
		"Shiny":"s",
		"Attacks":[
			{"Name":"Jet-Pierres"},
			{"Name":"Destruction"},
			{"Name":"Explosion"},
			{"Name":"Séisme"}
		],
		"Statut":[]},
	{"Name":"Feunard",
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
		"Nature":"Docile",
		"Damages":0,
		"Shiny":"n",
		"Attacks":[
			{"Name":"Hurlement"},
			{"Name":"Onde Folie"},
			{"Name":"Lance-Flammes"},
			{"Name":"Danse-Flammes"}],
		"Statut":[]},
]


#									-----GAME VAR-----
@onready var IA = $IA
var game_state = {}
var turn = 0
var Modifs = {1:{"Precision":0,"Esquive":0,"Critique":0,"Attaque":0,"Defense":0,"AttaqueSpe":0,"DefenseSpe":0,"Vitesse":0},2:{"Precision":0,"Esquive":0,"Critique":0,"Attaque":0,"Defense":0,"AttaqueSpe":0,"DefenseSpe":0,"Vitesse":0}}
var incomming_attacks = [null,null]
var Charging = ["",""]
var SleepCounter = [0,0,0,0,0,0,0,0,0,0,0,0]
var DanseFlammeCounter = [0,0]
var LigotageCounter = [0,0]
var ClaquoirCounter = [0,0]
var EtreinteCounter = [0,0]
var MurLumiereCounter = [0,0]
var ProtectionCounter = [0,0]
var LockCounter = [0,0]
var ConfuseCounter = [0,0,0,0,0,0,0,0,0,0,0,0]
var MimiqueAttack = ["",""]
var EntraveAttack = ["",""]
var EntraveCounter = [0,0]
var BrumeCounter = [0,0]
var ToxikCounter = [0,0]
var PreRiposteDamages = [0,0]
var Clones = [null,null]
var InitalMetamorphs = [null,null]
var MimicStun = [false,false]
var Fainted = [false,false]
var death_switch = false
var win_condition = null

var pokedollars_reward = 0
var participants_KO_exp = []


#									-----NODES-----
@onready var ClientNodes = {
	"Sprite": $Sprites/ClientPkmn,
	"Name": $UI/Pokemons_UI/Client/Margin/VBox/Label,
	"LvL": $UI/Pokemons_UI/Client/Margin/VBox/Label/LvL,
	"HealthBar": $UI/Pokemons_UI/Client/Margin/VBox/Bar,
	"HealthLabel": $UI/Pokemons_UI/Client/Margin/VBox/Bar/Label,
	"Block": $UI/Pokemons_UI/Client,
	"Pokeball": $Sprites/ClientBall,
	"BasePos": $Sprites/ClientPkmn.position,
	"ExpBar": $UI/Pokemons_UI/Client/Margin/ExpBar,
	"Clone": $Sprites/ClientClone,
	"StatutBlock": $UI/Pokemons_UI/Client/Statut,
	"StatutTexture": $UI/Pokemons_UI/Client/Statut/Texture,
}
@onready var OppNodes = {
	"Sprite": $Sprites/OppPkmn,
	"Name": $UI/Pokemons_UI/Opp/Margin/VBox/Label,
	"LvL": $UI/Pokemons_UI/Opp/Margin/VBox/Label/LvL,
	"HealthBar": $UI/Pokemons_UI/Opp/Margin/VBox/Bar,
	"HealthLabel": $UI/Pokemons_UI/Opp/Margin/VBox/Bar/Label,
	"Block": $UI/Pokemons_UI/Opp,
	"Pokeball": $Sprites/OppBall,
	"BasePos": $Sprites/OppPkmn.position,
	"Clone": $Sprites/OppClone,
	"StatutBlock": $UI/Pokemons_UI/Opp/Statut,
	"StatutTexture": $UI/Pokemons_UI/Opp/Statut/Texture,
}
@onready var TutoUI = {
	"Label": $UI/Tutorial_UI/Label,
	"Block": $UI/Tutorial_UI
}
@onready var MainUI = {
	"MainMenu": $UI/Main_UI/Basis_UI,
	"AtkMenu": $UI/Main_UI/Attack_UI,
	"PkmMenu": $UI/Main_UI/Pokemon_UI,
	"PkmVBox": $UI/Main_UI/Pokemon_UI/Margin/HBox/Pokemons/VBox,
	"PkmBack": $UI/Main_UI/Pokemon_UI/Margin/HBox/Margin/Back
}
@onready var ActionUI = {
	"Label": $UI/Action_UI/Margin/Label,
	"Block": $UI/Action_UI
}
@onready var PkmInfoUI = {
	"Block": $UI/Pkm_Info_UI,
	"Name": $UI/Pkm_Info_UI/Margin/VBox/Label,
	"LvL": $UI/Pkm_Info_UI/Margin/VBox/Label/LvL,
	"HealthBar": $UI/Pkm_Info_UI/Margin/VBox/Bar,
	"Health": $UI/Pkm_Info_UI/Margin/VBox/Bar/Label,
	"Atk1": $UI/Pkm_Info_UI/Margin/VBox/VBox/Atk1,
	"Atk2": $UI/Pkm_Info_UI/Margin/VBox/VBox/Atk2,
	"Atk3": $UI/Pkm_Info_UI/Margin/VBox/VBox/Atk3,
	"Atk4": $UI/Pkm_Info_UI/Margin/VBox/VBox/Atk4,
	"Statut": $UI/Pkm_Info_UI/Margin/VBox/Label/Statut,
}
@onready var DeathSwitchUI = {
	"Block": $UI/Death_Switch_UI,
	"Switch": $UI/Death_Switch_UI/Margin/VBox/Switch,
	"Continue": $UI/Death_Switch_UI/Margin/VBox/Continue,
}
@onready var Audios = {
	"Button" : $Audios/Button,
	"Attack" : $Audios/Attack,
	"SFX" : $Audios/SFX,
	"BGM" : $Audios/BGM,
	"Damages" : $Audios/Damages
}


#									-----Stats-----
func get_pokemon_img(face : String,pkm_name : String, shiny : String):
	var pokedex = Stats.POKEMONS.keys().find(pkm_name)+1
	return "res://Textures/Pokemons/%s/%s/%s.png" % [face,shiny,pokedex]

func get_pkm_nickname(pkm : Dictionary):
	if pkm.Nickname != null && pkm.Nickname != pkm.Name: return pkm.Nickname
	else:
		pkm.Nickname = null
		return pkm.Name

func get_nodes(plr : int):
	if plr == 1: return ClientNodes
	else: return OppNodes

func get_active_pokemon(plr : int):
	if plr == 1: return ClientDeck[ClientPokemon]
	else: return OppDeck[OppPokemon]

func get_deck(plr : int):
	if plr == 1: return ClientDeck
	else: return OppDeck

func get_alive_pokemons(deck : Array):
	var r = []
	for pkm in deck:
		if pkm.Damages < stat(pkm,"PV"):
			r.append(pkm)
	return r

func get_opp(plr : int):
	if plr == 1: return 2
	else: return 1

func get_types(pkm : Dictionary):
	var plr = pkm.Owner
	#Clone patch
	if Clones[plr-1] != null:
		if plr == 1: pkm = ClientDeck[ClientPokemon]
		else: pkm = OppDeck[OppPokemon]
	#Conversion (atk)
	for Statut in pkm.Statut:
		if Statut.begins_with("Conversion"):
			return [Statut.split(" ")[1],null]
	return [Stats.POKEMONS[pkm.Name].Type1,Stats.POKEMONS[pkm.Name].Type2]

func stat(pkm : Dictionary, Stat : String):
	var plr = pkm.Owner
	var Modif = Modifs[plr].get(Stat)
	var is_clone = pkm.Name == "Clone"
	if is_clone:
		if plr == 1: pkm = ClientDeck[ClientPokemon]
		else: pkm = OppDeck[OppPokemon]
	if Stat == "PV" :
		if get_active_pokemon(plr)==pkm && InitalMetamorphs[plr-1] != null:
			pkm = InitalMetamorphs[plr-1]
			pkm["LvL"] = get_active_pokemon(plr).LvL
		var Value = Stats.get_stat(pkm,Stat)
		if is_clone: return round(Value/4)
		else: return Value
	elif Stat == "Precision" || Stat == "Esquive" :
		return round(100*Stats.MODIF_PRE[Modif])
	else :
		var is_paralysed = Stat == "Vitesse" && pkm.Statut.has("Paralysé")
		var Value = Stats.get_stat(pkm,Stat)*Stats.MODIF_STAT[Modif]
		if is_paralysed: Value /= 2.0
		return Value

func _ready():
	OppDeck = create_randomized_team(6,50)
	game()
func game():
	if against_wildpkm:
		Audios.BGM.stream = load("res://Sounds/BGM/Battle! Wild.mp3")
	else :
		Audios.BGM.stream = load("res://Sounds/BGM/Battle! Trainer.mp3")
	Audios.BGM.playing = true
	
	var data = SaveManager.load_data()
	ClientTeamID = data.ActiveTeam
	ClientDeck = data.Teams[ClientTeamID].Team
	
	restart_game()
	reset_ui()
	ActionUI.Label.text = ""
	ActionUI.Block.visible = true
	MainUI.MainMenu.visible = false
	ClientNodes.Pokeball.visible = true
	OppNodes.Pokeball.visible = true
	await pokemon_activation(2,0)
	await pokemon_activation(1,0)
	preparation_phase()


#									-----GAME-----
func restart_game():
	turn = 0
	incomming_attacks = [null,null]
	Charging = ["",""]
	SleepCounter = [0,0,0,0,0,0,0,0,0,0,0,0]
	DanseFlammeCounter = [0,0]
	ToxikCounter = [0,0]
	LigotageCounter = [0,0]
	ClaquoirCounter = [0,0]
	EtreinteCounter = [0,0]
	MurLumiereCounter = [0,0]
	ProtectionCounter = [0,0]
	LockCounter = [0,0]
	ConfuseCounter = [0,0,0,0,0,0,0,0,0,0,0,0]
	MimiqueAttack = ["",""]
	EntraveAttack = ["",""]
	EntraveCounter = [0,0]
	BrumeCounter = [0,0]
	Clones = [null,null]
	InitalMetamorphs = [null,null]
	MimicStun = [false,false]
	Fainted = [false,false]
	death_switch = false
	win_condition = null
	pokedollars_reward = 0
	participants_KO_exp = []
	for pkm in ClientDeck:
		pkm["Damages"] = 0
		pkm["Statut"] = []
		pkm["Owner"] = 1
		for atk in pkm.Attacks:
			atk["PP"] = Stats.ATTACKS[atk.Name].PP
	for pkm in OppDeck:
		pkm["Damages"] = 0
		pkm["Statut"] = []
		pkm["Owner"] = 2
		for atk in pkm.Attacks:
			atk["PP"] = Stats.ATTACKS[atk.Name].PP

func end_game(issue : String):
	if InitalMetamorphs[0] != null:
		await unmorph_animation(1)
	if InitalMetamorphs[1] != null:
		await unmorph_animation(2)
	InitalMetamorphs = [null,null]
	
	game_state = ia_create_game_state()
	IA.feed(game_state)
	IA.save_q_table()
	
	ActionUI.Label.text = ""
	ActionUI.Block.visible = true
	MainUI.MainMenu.visible = false
	print(issue," ",win_condition)
	
	restart_game()
	var data = SaveManager.load_data()
	for pkm in ClientDeck:
		pkm.erase("Damages")
		pkm.erase("Statut")
		pkm.erase("Owner")
		for atk in pkm.Attacks:
			atk.erase("PP")
	data.Teams[ClientTeamID].Team = ClientDeck
	SaveManager.save_data(data)
	
	await wait(1)
	if issue == "Victoire":
		Audios.BGM.playing = false
		if against_wildpkm:
			Audios.BGM.stream = load("res://Sounds/BGM/Victory! Wild.mp3")
		else :
			Audios.BGM.stream = load("res://Sounds/BGM/Victory! Trainer.mp3")
		Audios.BGM.playing = true
	elif issue == "Défaite":
		pass
	elif issue == "Egalité":
		pass

func create_randomized_team(size : int = 6, team_lvl : int = randi_range(1,100), pool : Array = []):
	var new_team = []
	var all_pkm = Stats.POKEMONS.keys()
	if pool != []: all_pkm = pool
	for _i in range(size):
		if all_pkm.size() == 0: return new_team
		var random_pkm = all_pkm[randi_range(0,all_pkm.size()-1)]
		all_pkm.erase(random_pkm)
		var all_natures = Stats.NATURE.keys()
		var random_nature = all_natures[randi_range(0,all_natures.size()-1)]
		var is_shiny = ""
		if random_percent_check(1.0/512.0): is_shiny = "s"
		else: is_shiny = "n"
		var random_stats = {
			"PV":{"IV":randi_range(0,31),"EV":0},
			"Attaque":{"IV":randi_range(0,31),"EV":0},
			"Defense":{"IV":randi_range(0,31),"EV":0},
			"AttaqueSpe":{"IV":randi_range(0,31),"EV":0},
			"DefenseSpe":{"IV":randi_range(0,31),"EV":0},
			"Vitesse":{"IV":randi_range(0,31),"EV":0}}
		var all_moves = Stats.POKEMONS[random_pkm].NativeAttacks
		var learnable_moves = []
		for move in all_moves: if move.LvL<=team_lvl: learnable_moves.append(move.Attack)
		var random_moveset = []
		for _i2 in range(mini(4,learnable_moves.size())):
			var new_move = learnable_moves[randi_range(0,learnable_moves.size()-1)]
			random_moveset.append({"Name":new_move})
			learnable_moves.erase(new_move)
		var new_pkm = {
			"Name":random_pkm,
			"Nickname":null,
			"Stats":random_stats,
			"EXP":0,
			"LvL":team_lvl,
			"Nature":random_nature,
			"Damages":0,
			"Shiny":is_shiny,
			"Attacks":random_moveset,
			"Statut":[]
		}
		new_team.append(new_pkm)
	return new_team


#									-----PHASES-----
func preparation_phase():
	reset_ui()
	refresh_ui()
	game_state = ia_create_game_state()
	if Charging[0] != "":
		incomming_attacks[0] = Charging[0]
		attack_phase()
	elif get_active_pokemon(1).Statut.has("Ultralaser"):
		incomming_attacks[0] = "Ultralaser"
		attack_phase()
	elif LockCounter[0] != 0 || MimicStun[0] == true: attack_phase()
	else: MainUI.MainMenu.visible = true

func attack_phase():
	if against_bot:
		ia_moves(2)
	else: pass #SI PVP
	
	if win_check_phase(): return
	reset_ui()
	refresh_ui()
	ActionUI.Label.text = ""
	ActionUI.Block.visible = true
	MainUI.MainMenu.visible = false
	if !(incomming_attacks[0]=="Patience" && LockCounter[0]==0):
		PreRiposteDamages[0] = [get_active_pokemon(1).Damages]
	if !(incomming_attacks[1]=="Patience" && LockCounter[1]==0):
		PreRiposteDamages[1] = [get_active_pokemon(2).Damages]
	var clientfirst = first_pick_calculation()
	await wait(1)
	var alr_played = await switch_phase(clientfirst)
	var dead_check_ok = true
	if clientfirst:
		if alr_played[0] : await attack(1)
		dead_check_ok = not(await ingame_check_death())
		if dead_check_ok: 
			if alr_played[1] : await attack(2)
			dead_check_ok = not(await ingame_check_death())
	else :
		if alr_played[1] : await attack(2)
		dead_check_ok = not(await ingame_check_death())
		if dead_check_ok: 
			if alr_played[0] : await attack(1)
			dead_check_ok = not(await ingame_check_death())
	await end_turn_effects()
	game_state = ia_create_game_state()
	IA.feed(game_state)
	if !win_check_phase():
		dead_check_ok = not(await ingame_check_death())
		if dead_check_ok:
			preparation_phase()
		else:
			death_switch_phase()

func end_turn_effects():
	var effects = ["Brume","Frénésie","Entrave","Apeuré","Protection","Mur Lumière","Vampigraine",
	"Claquoir","Étreinte","Ligotage","Danse-Flammes","Brûlé","Empoisonné","Empoisonné Gravement"]
	var clientfirst = first_pick_calculation()
	for effect in effects:
		if clientfirst:
			await end_turn_effect_activation(1,effect)
			await ingame_check_death()
			await end_turn_effect_activation(2,effect)
			await ingame_check_death()
		else :
			await end_turn_effect_activation(2,effect)
			await ingame_check_death()
			await end_turn_effect_activation(1,effect)
			await ingame_check_death()

func switch_phase(clientfirst):
	var r = [true,true]
	if clientfirst:
		if incomming_attacks[0].begins_with("Switch"):
			r[0] = false
			await switch(1, ClientDeck[ClientPokemon],int(incomming_attacks[0][-1]))
		if incomming_attacks[1].begins_with("Switch"):
			r[1] = false
			await switch(2, OppDeck[OppPokemon],int(incomming_attacks[1][-1]))
	else:
		if incomming_attacks[1].begins_with("Switch"):
			r[1] = false
			await switch(2, OppDeck[OppPokemon],int(incomming_attacks[1][-1]))
		if incomming_attacks[0].begins_with("Switch"):
			r[0] = false
			await switch(1, ClientDeck[ClientPokemon],int(incomming_attacks[0][-1]))
	return r

func death_switch_phase():
	var pkm1 = ClientDeck[ClientPokemon]
	var pkm2 = OppDeck[OppPokemon]
	death_switch = true
	Fainted = [false,false]
	if pkm1.Damages >= stat(pkm1,"PV") && pkm2.Damages >= stat(pkm2,"PV"):
		MainUI.PkmBack.visible = false
		ia_death_switch(2)
		game_state = ia_create_game_state()
		_on_pokemon_pressed()
	elif pkm1.Damages >= stat(pkm1,"PV"):
		MainUI.PkmBack.visible = false
		_on_pokemon_pressed()
	elif pkm2.Damages >= stat(pkm2,"PV"):
		if allow_death_switch:
			DeathSwitchUI.Switch.disabled = false
			DeathSwitchUI.Continue.disabled = false
			DeathSwitchUI.Block.visible = true
		else:
			_on_continue_pressed()

func win_check_phase():
	var winner = check_win()
	if winner == 0:#Nobody wins
		return false
	elif winner == 3:#Both players have losed
		end_game("Egalité")
	else:#A player have won
		if winner == 1: end_game("Victoire")
		else: end_game("Défaite")
	return true

func XP_phase():
	var a
	if against_wildpkm: a = 1
	else: a = 1.5
	var s = 0
	var target = OppDeck[OppPokemon]
	var b = Stats.POKEMONS[target.Name].EXP
	var N = target.LvL
	for i in participants_KO_exp:
		var pkm = ClientDeck[i]
		if pkm.Damages < stat(pkm,"PV"):
			s += 1
	s *= 2
	var EXP = round((a*b*N)/(7*s))
	for i in participants_KO_exp:
		var pkm = ClientDeck[i]
		if pkm.Damages < stat(pkm,"PV"): await exp_animation(pkm,EXP)
	participants_KO_exp.clear()


#									-----ACTIONS-----
func attack(plr : int):
	var pkm = get_active_pokemon(plr)
	var target = get_active_pokemon(get_opp(plr))
	if Clones[plr-1] != null: target = Clones[plr-1]
	var atk = incomming_attacks[plr-1]
	if await before_attack_effects(plr):
		LockCounter[plr-1] = 0
		Charging[plr-1] = ""
		return
	if Charging[get_opp(plr)-1] == "Vol" && atk!="Tornade":
		LockCounter[plr-1] = 0
		Charging[plr-1] = ""
		return
	if Charging[get_opp(plr)-1] == "Tunnel" && atk!="Séisme" && atk!="Abîme":
		if plr==1: await action_ui_writing("Le %s ennemi a été pris par surprise et ne peut pas bouger !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("%s a été pris par surprise et ne peut pas bouger !" % get_pkm_nickname(pkm))
		LockCounter[plr-1] = 0
		Charging[plr-1] = ""
		await wait(2)
		return
	if pkm.Statut.has("Ultralaser"):
		pkm.Statut.erase("Ultralaser")
		if plr==1: await action_ui_writing("%s a besoin de repos !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi a besoin de repos !" % get_pkm_nickname(pkm))
		await wait(2)
		return
	var old_pkm = pkm
	var old_target = pkm
	if plr==1:await action_ui_writing("%s utilise %s !" % [get_pkm_nickname(pkm),atk])
	else :await action_ui_writing("Le %s ennemi utilise %s !" % [get_pkm_nickname(pkm),atk])
	await wait(1)
	Charging[plr-1] = await attack_charge(plr,atk)
	if Charging[plr-1] != "": return
	if (atk == "Riposte" || atk == "Patience") && (pkm.Damages <= PreRiposteDamages[plr-1] || get_types(target).has("Spectre")):
		await action_ui_writing("Mais cela échoue...")
		await wait(2)
		return
	elif atk == "Patience":
		if plr==1:await action_ui_writing("%s envoie la sauce !" % get_pkm_nickname(pkm))
		else :await action_ui_writing("Le %s ennemi envoie la sauce !" % get_pkm_nickname(pkm))
		await wait(2)
	if atk == "Dévorêve" && !target.Statut.has("Endormi"):
		await action_ui_writing("Mais cela échoue...")
		await wait(2)
		return
	for a in pkm.Attacks:
		if a.Name == atk:
			if a.PP == 0:
				await action_ui_writing("Mais cela échoue...")
				await wait(2)
				return
			elif LockCounter[plr-1] == 0:
				a.PP -= 1
				if a.PP > 0 && !pkm.Statut.has("Entrave"): EntraveAttack[plr-1] = a.Name
	if atk != "Mimique" || atk != "Copie":
		attack_animation(plr,atk)
		await wait(0.5)
	if (atk == "Pied Sauté" || atk == "Pied Voltige") && get_types(target).has("Spectre"):
		await damage_animation(plr,round(stat(pkm,"PV")/2),1)
		if plr == 1: await action_ui_writing("%s est blessé par le contrecoup !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi est blessé par le contrecoup !" % get_pkm_nickname(pkm))
	if !precision_calculation(pkm,target,atk) || (Charging[get_opp(plr)-1]=="Vol" && !(atk=="Tornade" || atk=="Fatal-Foudre")):
		if plr==1: await action_ui_writing("Le %s ennemi esquive l'attaque !" % get_pkm_nickname(target))
		else : await action_ui_writing("%s esquive l'attaque !" % get_pkm_nickname(target))
		if atk == "Pied Sauté" || atk == "Pied Voltige":
			await wait(1)
			await damage_animation(plr,round(stat(pkm,"PV")/2),1)
			if plr == 1: await action_ui_writing("%s est blessé par le contrecoup !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est blessé par le contrecoup !" % get_pkm_nickname(pkm))
	else :
		var weakness = weakness_calculation(atk,target)
		if weakness == 0.0:
			await weakness_animation(weakness)
		else:
			if Stats.ATTACKS[atk].Categorie == "Statut" :
				await attaque_statut(plr,atk)
			else:
				var crit = crit_check(plr)
				var damages = 0
				var hits_number = get_hits_number(plr)
				if Clones[plr-1]!=null && atk != "Clonage": await clone_disapear_animation(plr)
				for i in range(hits_number):
					damages = damage_calculation(pkm,target,atk,crit,weakness)
					if !crit && MurLumiereCounter[get_opp(plr)-1]>0 && Stats.ATTACKS[atk].Categorie == "Special": damages/=2.0
					if !crit && ProtectionCounter[get_opp(plr)-1]>0 && Stats.ATTACKS[atk].Categorie == "Physique": damages/=2.0
					await damage_animation(get_opp(plr),damages,weakness,false)
					if hits_number > i+1:
						if atk == "Furie" || atk == "Combo-Griffe" || atk == "Torgnoles" || atk == "Pilonnage" || atk == "Poing Comète": crit = false
						elif atk == "Dard-Nuée" || atk == "Double Pied": crit = crit_check(plr)
						await wait(1)
						attack_animation(plr,atk)
						await wait(0.5)
				await attack_side_effect(plr,atk,
					{
						"Damages":damages,
					})
				if hits_number > 1 :
					await action_ui_writing("Touché %s fois !" % hits_number)
					await wait(1)
				if crit == true: await crit_animation()
				ActionUI.Label["theme_override_colors/font_color"] = Color8(255,255,255)
				if weakness != 1: await weakness_animation(weakness)
				ActionUI.Label.text = ""
				if Clones[plr-1]!=null && atk != "Clonage":
					await clone_exchange_animation(plr)
		if target.Statut.has("Gelé") && Stats.ATTACKS[atk].Type == "Feu":
			await wait(1)
			target.Statut.erase("Gelé")
			status_animation()
			if plr==1: await action_ui_writing("Le %s ennemi est dégelé !" % get_pkm_nickname(target))
			else : await action_ui_writing("%s est dégelé !" % get_pkm_nickname(target))
		if atk != "Mimique" && atk != "Métronome" && atk != "Riposte" && atk != "Patience" && atk != "Morphing" && atk != "Lutte" && atk != "Copie" && MimicStun[plr-1] == false:
			if pkm != old_pkm:
				MimiqueAttack[plr-1] = atk
			if target != old_target:
				MimiqueAttack[get_opp(plr)-1] = atk
	await wait(2)

func before_attack_effects(plr : int):
	var pkm = get_active_pokemon(plr)
	for i in range(6):
		var I = int(plr==2)*6+i
		var is_active = false
		if plr == 1: is_active = (i == ClientPokemon)
		else: is_active = (i == OppPokemon)
		if SleepCounter[I] > 0:
			SleepCounter[I] -= 1
			if is_active:
				Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Sleep.mp3")
				Audios.Attack.playing = true
				if plr == 1: await action_ui_writing("%s est endormi..." % get_pkm_nickname(pkm))
				else: await action_ui_writing("Le %s ennemi est endormi..." % get_pkm_nickname(pkm))
				await wait(2)
		elif is_active && pkm.Statut.has("Endormi"):
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Sleep.mp3")
			Audios.Attack.playing = true
			pkm.Statut.erase("Endormi")
			status_animation()
			if plr == 1: await action_ui_writing("%s se réveille !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi se réveille !" % get_pkm_nickname(pkm))
			await wait(1)
	if pkm.Statut.has("Endormi"):
		return true
	if pkm.Statut.has("Confus"):
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Confused.mp3")
		Audios.Attack.playing = true
		if plr == 1:
			if ConfuseCounter[ClientPokemon] == 0:
				pkm.Statut.erase("Confus")
				await action_ui_writing("%s n'est plus confus !" % get_pkm_nickname(pkm))
			else:
				ConfuseCounter[ClientPokemon] -= 1
				await action_ui_writing("%s est confus !" % get_pkm_nickname(pkm))
		else:
			if ConfuseCounter[OppPokemon+6] == 0:
				pkm.Statut.erase("Confus")
				await action_ui_writing("Le %s ennemi n'est plus confus !" % get_pkm_nickname(pkm))
			else:
				ConfuseCounter[OppPokemon+6] -= 1
				await action_ui_writing("Le %s ennemi est confus !" % get_pkm_nickname(pkm))
		await wait(1)
		if pkm.Statut.has("Confus"):
			if random_percent_check(33):
				await action_ui_writing("Il se blesse dans sa confusion !")
				var damages = damage_calculation(pkm,pkm,"Statut_Confus",false,1.0)
				await damage_animation(plr,damages,1.0)
				await wait(1)
				return true
		else: status_animation()
	if pkm.Statut.has("Paralysé") && random_percent_check(25):
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Paralyzed.mp3")
		Audios.Attack.playing = true
		if plr==1: await action_ui_writing("%s est paralysé ! Il ne peut pas attaquer..." % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi est paralysé ! Il ne peut pas attaquer..." % get_pkm_nickname(pkm))
		await wait(1)
		return true
	if pkm.Statut.has("Gelé"):
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Frozen.mp3")
		Audios.Attack.playing = true
		if random_percent_check(20):
			pkm.Statut.erase("Gelé")
			status_animation()
			if plr==1: await action_ui_writing("%s n'est plus gelé !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi n'est plus gelé !" % get_pkm_nickname(pkm))
			await wait(1)
		else:
			if plr==1: await action_ui_writing("%s est gelé !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est gelé !" % get_pkm_nickname(pkm))
			await wait(1)
			return true
	if pkm.Statut.has("Apeuré"):
		if plr == 1: await action_ui_writing("%s est apeuré ! Il ne peut pas attaquer !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi est apeuré ! Il ne peut pas attaquer !" % get_pkm_nickname(pkm))
		await wait(1)
		return true
	return false

func get_hits_number(plr : int):
	var atk = incomming_attacks[plr-1]
	if atk == "Furie" || atk == "Dard-Nuée" || atk == "Combo-Griffe" || atk == "Torgnoles" || atk == "Picanon" || atk == "Pilonnage" || atk == "Poing Comète":
		if incomming_attacks[get_opp(plr)-1] == "Riposte" || incomming_attacks[get_opp(plr)-1] == "Patience":
			return 1
		else:
			var h = 2
			if random_percent_check(37.5):
				h = 3
				if random_percent_check(12.5):
					h = 4
					if random_percent_check(12.5):
						h = 5
			return h
	elif atk == "Double-Dard" || atk == "Osmerang":
		return 2
	elif atk == "Double Pied":
		if incomming_attacks[get_opp(plr)-1] == "Riposte" || incomming_attacks[get_opp(plr)-1] == "Patience": return 1
		else: return 2
	else:
		return 1

func attack_charge(plr : int, atk : String):
	if Charging[plr-1] == "":
		var pkm = get_active_pokemon(plr)
		if atk == "Lance Soleil":
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Charge/Charge Lance Soleil.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s absorbe la lumière !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi absorbe la lumière !" % get_pkm_nickname(pkm))
			await wait(2)
			return atk
		elif atk == "Coud'Krâne":
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Charge/Charge Coud'Krâne.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s baisse la tête !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi baisse la tête !" % get_pkm_nickname(pkm))
			await wait(1)
			await change_stat_pkm(plr,"Defense",1,true,false)
			await wait(2)
			return atk
		elif atk == "Tunnel":
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Charge/Charge Tunnel.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s se cache dans le sol !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi se cache dans le sol !" % get_pkm_nickname(pkm))
			await wait(2)
			return atk
		elif atk == "Piqué":
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Charge/Charge Piqué.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s est entouré d'une lumière intense !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi est entouré d'une lumière intense !" % get_pkm_nickname(pkm))
			await wait(2)
			return atk
		elif atk == "Coupe-Vent":
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Charge/Charge Coupe-Vent.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s se prépare à lancer une bourrasque !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi se prépare à lancer une bourrasque !" % get_pkm_nickname(pkm))
			await wait(2)
			return atk
		elif atk == "Patience":
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Charge/Charge Patience.mp3")
			Audios.Attack.playing = true
			if plr==1:await action_ui_writing("%s se concentre !" % get_pkm_nickname(pkm))
			else :await action_ui_writing("Le %s ennemi se concentre !" % get_pkm_nickname(pkm))
			await wait(2)
			return atk
	return ""

func attaque_statut(plr : int, atk : String):
	var pkm = get_active_pokemon(plr)
	var target = get_active_pokemon(get_opp(plr))
	await wait(1)
	if atk == "Rugissement":
		await change_stat_pkm(get_opp(plr),"Attaque",-1,true,true)
	elif atk == "Vampigraine":
		if target.Statut.has("Vampigraine"):
			await action_ui_writing("Mais cela échoue...")
		else:
			if get_types(pkm).has("Plante"):
				await action_ui_writing("Mais ça ne l'affecte pas...")
			else:
				target.Statut.append("Vampigraine")
				if plr == 1:await action_ui_writing("Le %s ennemi est infecté !" % get_pkm_nickname(target))
				else : await action_ui_writing("%s est infecté !" % get_pkm_nickname(target))
	elif atk == "Poudre Toxik":
		if get_types(pkm).has("Plante"):
			await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			await poison_pkm(get_opp(plr),true,true)
	elif atk == "Gaz Toxik":
		await poison_pkm(get_opp(plr),true,true)
	elif atk == "Croissance":
		if Modifs[plr].Attaque == 6 && Modifs[plr].AttaqueSpe == 6:
			await action_ui_writing("Mais cela échoue...")
		else :
			await change_stat_pkm(plr,"Attaque",1,false,false)
			await wait(1)
			await change_stat_pkm(plr,"AttaqueSpe",1,false,false)
	elif atk == "Poudre Dodo":
		if get_types(pkm).has("Plante"):
			await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			await sleep_pkm(get_opp(plr),true,true)
	elif atk == "Groz'Yeux" || atk == "Mimi-Queue":
		await change_stat_pkm(get_opp(plr),"Defense",-1,true,true)
	elif atk == "Repli" || atk == "Armure" || atk == "Boul'Armure":
		await change_stat_pkm(plr,"Defense",1,true,false)
	elif atk == "Sécrétion":
		await change_stat_pkm(get_opp(plr),"Vitesse",-2,true,true)
	elif atk == "Para-Spore":
		if get_types(pkm).has("Plante"):
			await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			paralyse_pkm(get_opp(plr),true,true)
	elif atk == "Ultrason" || atk == "Onde Folie":
		await confuse_pkm(get_opp(plr),true,true)
	elif atk == "Cyclone" || atk == "Hurlement":
		if against_wildpkm :
			incomming_attacks[plr-1] = "Fuite"
		else :
			var deck = get_deck(get_opp(plr))
			var current = get_active_pokemon(get_opp(plr))
			var apkms = get_alive_pokemons(deck).filter(func(p): return p != current)
			if pkm.LvL < target.LvL || len(apkms) == 1:
				await action_ui_writing("Mais cela échoue...")
			else:
				var apkms_n = apkms[randi_range(0,apkms.size()-1)]
				var deck_n = deck.find(apkms_n)
				await switch(get_opp(plr),current,deck_n)
	elif atk == "Puissance":
		if pkm.Statut.has("Puissance"):
			await action_ui_writing("Mais cela échoue...")
		else:
			pkm.Statut.append("Puissance")
			Modifs[plr].Critique += 2
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Stat Up.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s est prêt à tout donner !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est prêt à tout donner !" % get_pkm_nickname(pkm))
	elif atk == "Hâte":
		await change_stat_pkm(plr,"Vitesse",2,true,false)
	elif atk == "Jet de Sable" || atk == "Télékinésie" || atk == "Brouillard":
		await change_stat_pkm(get_opp(plr),"Precision",-1,true,true)
	elif atk == "Mimique":
		if MimiqueAttack[plr-1] == "":
			await action_ui_writing("Mais cela échoue...")
		else:
			incomming_attacks[plr-1] = MimiqueAttack[plr-1]
			await attack(plr)
	elif atk == "Regard Médusant" || atk == "Cage-Éclair":
		paralyse_pkm(get_opp(plr),true,true)
	elif atk == "Grincement":
		await change_stat_pkm(get_opp(plr),"Defense",-2,true,true)
	elif atk == "Reflet":
		await change_stat_pkm(plr,"Esquive",1,true,false)
	elif atk == "Mur Lumière":
		if MurLumiereCounter[plr-1] > 0:
			await action_ui_writing("Mais cela échoue...")
		else:
			MurLumiereCounter[plr-1] = 5 +1#+1 pour la détection au dernier tour
			if plr == 1: await action_ui_writing("Mur Lumière augmente la résistance de l'équipe aux capacités spéciales !")
			else : await action_ui_writing("Mur Lumière augmente la résistance de l'équipe ennemie aux capacités spéciales !")
	elif atk == "Berceuse" || atk == "Spore" || atk == "Hypnose" || atk == "Grobisou":
		await sleep_pkm(get_opp(plr),true,true)
	elif atk == "Lilliput":
		pkm.Statut.append("Lilliput")
		await change_stat_pkm(plr,"Esquive",2,true,false)
	elif atk == "Métronome":
		var all_atk_list = Stats.ATTACKS.keys()
		all_atk_list.erase("Riposte")
		all_atk_list.erase("Patience")
		all_atk_list.erase("Morphing")
		all_atk_list.erase("Lutte")
		all_atk_list.erase("Copie")
		all_atk_list.erase("Métronome")
		all_atk_list.erase("Statut_Confus")
		var random_atk = all_atk_list[randi_range(0,all_atk_list.size()-1)]
		incomming_attacks[plr-1] = random_atk
		await attack(plr)
	elif atk == "Entrave":
		if target.Statut.has("Entrave") || EntraveAttack[get_opp(plr)-1] == "":
			await action_ui_writing("Mais cela échoue...")
		else:
			target.Statut.append("Entrave")
			EntraveCounter[get_opp(plr)-1] = 4+1
			if plr == 1: await action_ui_writing("La capacité %s du %s ennemi est mise sous entrave !" % [EntraveAttack[get_opp(plr)-1],get_pkm_nickname(target)])
			else : await action_ui_writing("La capacité %s de %s est mise sous entrave !" % [EntraveAttack[get_opp(plr)-1],get_pkm_nickname(target)])
	elif atk == "Repos":
		if pkm.Damages >= stat(pkm,"PV"):
			await action_ui_writing("Mais cela échoue...")
		else:
			if pkm.Statut.has("Puissance"):
				pkm.Statut.clear()
				pkm.Statut.append("Puissance")
			else: pkm.Statut.clear()
			DanseFlammeCounter[plr-1] = 0
			ToxikCounter[plr-1] = 0
			LigotageCounter[plr-1] = 0
			ClaquoirCounter[plr-1] = 0
			EtreinteCounter[plr-1] = 0
			await sleep_pkm(plr,false,false)
			await wait(1)
			if plr == 1:
				ConfuseCounter[ClientPokemon] = 0
				SleepCounter[ClientPokemon] = 2
				await action_ui_writing("%s a récupéré en dormant !" % get_pkm_nickname(pkm))
			else:
				ConfuseCounter[OppPokemon+6] = 0
				SleepCounter[OppPokemon+6] = 2
				await action_ui_writing("Le %s ennemi a récupéré en dormant !" % get_pkm_nickname(pkm))
			await damage_animation(plr,-pkm.Damages,1)
	elif atk == "Buée Noire":
		reset_modifs(1)
		reset_modifs(2)
		await action_ui_writing("Les changements de Stats ont tous été annulés !")
	elif atk == "Amnésie":
		await change_stat_pkm(plr,"DefenseSpe",2,true,false)
	elif atk == "Téléport":
		if against_wildpkm : incomming_attacks[plr-1] = "Fuite"
		else : await action_ui_writing("Mais cela échoue...")
	elif atk == "Soin":
		var heal = stat(pkm,"PV")/2.0-pkm.Damages
		await damage_animation(plr,heal,1)
		if plr == 1: await action_ui_writing("%s a récupéré des PV !" % get_pkm_nickname(pkm))
		else: await action_ui_writing("Le %s ennemi a récupéré des PV !" % get_pkm_nickname(pkm))
	elif atk == "Protection":
		if ProtectionCounter[plr-1] > 0:
			await action_ui_writing("Mais cela échoue...")
		else:
			ProtectionCounter[plr-1] = 5 +1#+1 pour la détection au dernier tour
			if plr == 1: await action_ui_writing("Protection augmente la résistance de l'équipe aux capacités physiques !")
			else : await action_ui_writing("Protection augmente la résistance de l'équipe ennemie aux capacités physiques !")
	elif atk == "Bouclier" || atk == "Acidarmure":
		await change_stat_pkm(plr,"Defense",2,true,false)
	elif atk == "Danse-Lames":
		await change_stat_pkm(plr,"Attaque",2,true,false)
	elif atk == "Yoga" || atk == "Affûtage":
		await change_stat_pkm(plr,"Attaque",1,true,false)
	elif atk == "Clonage":
		var cost = round(stat(pkm,"PV")/4)
		if pkm.Damages >= 3*cost || Clones[plr-1] != null:
			await action_ui_writing("Mais cela échoue...")
		else:
			await damage_animation(plr,cost,1)
			await wait(0.5)
			Clones[plr-1] = {
				"Name":"Clone",
				"Owner":plr,
				"Damages":0,
				"Statut":[]
			}
			pkm.Statut.erase("Etreinte")
			pkm.Statut.erase("Danse-Flammes")
			pkm.Statut.erase("Claquoir")
			pkm.Statut.erase("Ligotage")
			if plr == 1: await action_ui_writing("%s crée un clone !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi crée un clone !" % get_pkm_nickname(pkm))
	elif atk == "Trempette":
		if random_percent_check(0.1):
			Audios.BGM.stream = load("res://Sounds/BGM/BattleTower.mp3")
			Audios.BGM.playing = true
			await action_ui_writing("QUOI?!?!")
			await wait(2)
			await action_ui_writing("QUE SE PASSE T-IL ?!?!")
			await wait(2)
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Croissance.mp3")
			Audios.Attack.playing = true
			await action_ui_writing("%s CHARGE TOUTE SA PUISSANCE !!!" % get_pkm_nickname(pkm))
			await wait(2)
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Pied Sauté.mp3")
			Audios.Attack.playing = true
			await action_ui_writing("%s SAUTE ET IMITE LE METEORE !!!" % get_pkm_nickname(pkm))
			await wait(0.9)
			await damage_animation(get_opp(plr),stat(get_active_pokemon(get_opp(plr)),"PV"),4)
		else:
			await action_ui_writing("Mais rien ne se passe...")
	elif atk == "Brume":
		if BrumeCounter[plr-1] > 0:
			await action_ui_writing("Mais cela échoue...")
		else:
			BrumeCounter[plr-1] = 5
			if plr == 1: await action_ui_writing("La brume enveloppe votre équipe !")
			else : await action_ui_writing("La brume enveloppe l'équipe adverse !")
	elif atk == "Morphing":
		if InitalMetamorphs[plr-1] != null:
			await action_ui_writing("Mais cela échoue...")
		else:
			InitalMetamorphs[plr-1] = {
				"Name":pkm.Name,
				"Nickname":pkm.Nickname,
				"Stats":{
					"PV":{"IV":pkm.Stats.PV.IV,"EV":pkm.Stats.PV.EV},
					"Attaque":{"IV":pkm.Stats.Attaque.IV,"EV":pkm.Stats.Attaque.EV},
					"Defense":{"IV":pkm.Stats.Defense.IV,"EV":pkm.Stats.Defense.EV},
					"AttaqueSpe":{"IV":pkm.Stats.AttaqueSpe.IV,"EV":pkm.Stats.AttaqueSpe.EV},
					"DefenseSpe":{"IV":pkm.Stats.DefenseSpe.IV,"EV":pkm.Stats.DefenseSpe.EV},
					"Vitesse":{"IV":pkm.Stats.Vitesse.IV,"EV":pkm.Stats.Vitesse.EV}},
				"Shiny":"n",
				"Attacks":[]
			}
			for a in pkm.Attacks: InitalMetamorphs[plr-1].Attacks.append({"Name":a.Name,"PP":a.PP})
			pkm.Nickname = get_pkm_nickname(pkm)
			pkm.Name = target.Name
			pkm.Shiny = target.Shiny
			pkm.Stats = {
				"PV":{"IV":pkm.Stats.PV.IV,"EV":pkm.Stats.PV.EV},
				"Attaque":{"IV":target.Stats.Attaque.IV,"EV":target.Stats.Attaque.EV},
				"Defense":{"IV":target.Stats.Defense.IV,"EV":target.Stats.Defense.EV},
				"AttaqueSpe":{"IV":target.Stats.AttaqueSpe.IV,"EV":target.Stats.AttaqueSpe.EV},
				"DefenseSpe":{"IV":target.Stats.DefenseSpe.IV,"EV":target.Stats.DefenseSpe.EV},
				"Vitesse":{"IV":target.Stats.Vitesse.IV,"EV":target.Stats.Vitesse.EV}}
			await morph_animation(plr)
			pkm.Attacks.clear()
			for ta in target.Attacks: pkm.Attacks.append({"Name":ta.Name,"PP":5})
			if plr == 1: await action_ui_writing("%s prend l'apparence du %s ennemi !" % [get_pkm_nickname(InitalMetamorphs[plr-1]),get_pkm_nickname(target)])
			else: await action_ui_writing("Le %s ennemi prend l'apparence de %s !" % [get_pkm_nickname(InitalMetamorphs[plr-1]),get_pkm_nickname(target)])
	elif atk == "Conversion":
		var type = ""
		var force = -1
		var types_target = get_types(target)
		for type_player in Stats.TABLE_TYPE:
			var force_test = 1
			force_test *= weak_check(type_player,types_target[0])
			if types_target[1] != null: force_test *= weak_check(type_player,types_target[1])
			if force_test > force:
				force = force_test
				type = type_player
		var statut = "Conversion %s" % type
		if type == "" || pkm.Statut.has(statut): await action_ui_writing("Mais cela échoue...")
		else:
			pkm.Statut.append(statut)
			if plr == 1: await action_ui_writing("%s prend le type %s !" % [get_pkm_nickname(pkm),type])
			else: await action_ui_writing("Le %s ennemi prend le type %s !" % [get_pkm_nickname(pkm),type])
	elif atk == "Toxik":
		await deep_poison_pkm(get_opp(plr),true,true)
	elif atk == "Copie":
		if MimiqueAttack[plr-1] == "":
			await action_ui_writing("Mais cela échoue...")
		else:
			MimicStun[plr-1] = true
			incomming_attacks[plr-1] = MimiqueAttack[plr-1]
			await attack(plr)
	elif atk == "E-Coque":
		var heal = stat(pkm,"PV")/2.0
		await damage_animation(plr,heal,1)
		if plr == 1: await action_ui_writing("%s a récupéré des PV !" % get_pkm_nickname(pkm))
		else: await action_ui_writing("Le %s ennemi a récupéré des PV !" % get_pkm_nickname(pkm))
	else : return
	await wait(2)

func attack_side_effect(plr : int, atk : String, bulk : Dictionary = {}):
	var pkm = get_active_pokemon(plr)
	var target = get_active_pokemon(get_opp(plr))
	if target.Statut.has("Frénésie"):
		if bulk.Damages > 0:
			await change_stat_pkm(get_opp(plr),"Attaque",1,true,true)
			await wait(2)
	
	if atk == "Lutte":
		await damage_animation(plr,round(stat(pkm,"PV")/4),1)#S'inflige lui-même 1/4 de sa vie
		if plr == 1: await action_ui_writing("%s est blessé par le contrecoup !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi est blessé par le contrecoup !" % get_pkm_nickname(pkm))
	elif atk == "Flammèche" || atk == "Lance-Flammes" || atk == "Poing de Feu" || atk == "Déflagration":
		if random_percent_check(10): await burn_pkm(get_opp(plr),false,true)
	elif atk == "Frénésie" || atk == "Ultralaser":
		if !pkm.Statut.has(atk):
			pkm.Statut.append(atk)
			return
	elif atk == "Danse-Flammes" && Clones[get_opp(plr)-1] == null:
		if !target.Statut.has("Danse-Flammes"):
			target.Statut.append("Danse-Flammes")
			if plr == 1:
				DanseFlammeCounter[1] = randi_range(4,5)
				await action_ui_writing("Le %s ennemi est piégé dans un tourbillon de feu !" % get_pkm_nickname(target))
			else :
				DanseFlammeCounter[0] = randi_range(4,5)
				await action_ui_writing("%s est piégé dans un tourbillon de feu !" % get_pkm_nickname(target))
	elif atk == "Écume" || atk == "Constriction" || atk == "Bulles d'O":
		if random_percent_check(10): await change_stat_pkm(get_opp(plr),"Vitesse",-1,false,true)
	elif atk == "Morsure" || atk == "Croc de Mort" || atk == "Massd'Os":
		if random_percent_check(10): await scare_pkm(get_opp(plr),true)
	elif atk == "Choc Mental" || atk == "Rafale Psy":
		if random_percent_check(10): await confuse_pkm(get_opp(plr),false,true)
	elif atk == "Dard-Venin" || atk == "Détritus":
		if random_percent_check(30): await poison_pkm(get_opp(plr),false,true)
	elif atk == "Double-Dard":
		if random_percent_check(36): await poison_pkm(get_opp(plr),false,true)
	elif atk == "Ligotage" && Clones[get_opp(plr)-1] == null:
		if !target.Statut.has("Ligotage") && !get_types(pkm).has("Spectre"):
			target.Statut.append("Ligotage")
			if plr == 1:
				LigotageCounter[1] = randi_range(4,5)
				await action_ui_writing("Le %s ennemi est ligoté par %s !" % [get_pkm_nickname(get_active_pokemon(get_opp(plr))),get_pkm_nickname(pkm)])
			else :
				LigotageCounter[0] = randi_range(4,5)
				await action_ui_writing("%s est ligoté par %s !" % [get_pkm_nickname(get_active_pokemon(get_opp(plr))),get_pkm_nickname(pkm)])
	elif atk == "Acide" || atk == "Psyko":
		if random_percent_check(10): await change_stat_pkm(get_opp(plr),"DefenseSpe",-1,false,true)
	elif atk == "Éclair" || atk == "Tonnerre" || atk == "Poing-Éclair":
		if random_percent_check(10): await paralyse_pkm(get_opp(plr),false,true)
	elif atk == "Fatal-Foudre" || atk == "Plaquage" || atk == "Léchouille":
		if random_percent_check(30): await paralyse_pkm(get_opp(plr),false,true)
	elif atk == "Mania" || atk == "Danse-Fleur":
		if LockCounter[plr-1] == 0: LockCounter[plr-1] = randi_range(2,3)
		elif LockCounter[plr-1] > 0:
			LockCounter[plr-1] -= 1
			if LockCounter[plr-1] == 0: await confuse_pkm(plr,false,false)
	elif atk == "Damoclès":
		await damage_animation(plr,round(bulk.Damages/3),1)
		if plr == 1: await action_ui_writing("%s est blessé par le contrecoup !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi est blessé par le contrecoup !" % get_pkm_nickname(pkm))
	elif atk == "Vampirisme" || atk == "Vol-Vie" || atk == "Dévorêve" || atk == "Méga-Sangsue":
		await damage_animation(plr,-round(bulk.Damages/2),1)
		if plr == 1: await action_ui_writing("L'énergie du %s ennemi est drainée !" % get_pkm_nickname(target))
		else : await action_ui_writing("L'énergie de %s est drainée !" % get_pkm_nickname(target))
	elif atk == "Jackpot":
		if plr == 1: pokedollars_reward += pkm.LvL*5
		await action_ui_writing("Il pleut des pièces !")
	elif atk == "Bélier" || atk == "Sacrifice":
		await damage_animation(plr,round(bulk.Damages/4),1)
		if plr == 1: await action_ui_writing("%s est blessé par le contrecoup !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi est blessé par le contrecoup !" % get_pkm_nickname(pkm))
	elif atk == "Destruction" || atk == "Explosion":
		await damage_animation(plr,stat(pkm,"PV"),1)
	elif atk == "Coup d'Boule" || atk == "Mawashi Geri" || atk == "Piqué" || atk == "Éboulement":
		if random_percent_check(30): await scare_pkm(get_opp(plr),true)
	elif atk == "Triplattaque":
		if random_percent_check(6.67): await burn_pkm(get_opp(plr),false,true)
		elif random_percent_check(6.67): await froze_pkm(get_opp(plr),false,true)
		elif random_percent_check(6.67): await paralyse_pkm(get_opp(plr),false,true)
	elif atk == "Onde Boréale":
		if random_percent_check(10): await change_stat_pkm(get_opp(plr),"Attaque",-1,false,true)
	elif atk == "Laser Glace" || atk == "Poinglace" || atk == "Blizzard":
		if random_percent_check(10): await froze_pkm(get_opp(plr),false,true)
	elif atk == "Claquoir" && Clones[get_opp(plr)-1] == null:
		if !target.Statut.has("Claquoir"):
			target.Statut.append("Claquoir")
			if plr == 1:
				ClaquoirCounter[1] = randi_range(4,5)
				await action_ui_writing("Le %s ennemi est pris dans le claquoir de %s !" % [get_pkm_nickname(get_active_pokemon(get_opp(plr))),get_pkm_nickname(pkm)])
			else :
				ClaquoirCounter[0] = randi_range(4,5)
				await action_ui_writing("%s est pris dans le claquoir du %s ennemi !" % [get_pkm_nickname(get_active_pokemon(get_opp(plr))),get_pkm_nickname(pkm)])
	elif atk == "Étreinte" && Clones[get_opp(plr)-1] == null:
		if !target.Statut.has("Étreinte") && !get_types(pkm).has("Spectre"):
			target.Statut.append("Étreinte")
			if plr == 1:
				EtreinteCounter[1] = randi_range(4,5)
				await action_ui_writing("Le %s ennemi est pris dans l'étreinte de %s !" % [get_pkm_nickname(get_active_pokemon(get_opp(plr))),get_pkm_nickname(pkm)])
			else :
				EtreinteCounter[0] = randi_range(4,5)
				await action_ui_writing("%s est pris dans l'étreinte du %s ennemi !" % [get_pkm_nickname(get_active_pokemon(get_opp(plr))),get_pkm_nickname(pkm)])
	elif atk == "Purédpois":
		if random_percent_check(40): await poison_pkm(get_opp(plr),false,true)
	elif atk == "Uppercut":
		if random_percent_check(20): await confuse_pkm(get_opp(plr),false,true)
	elif atk == "Cascade":
		if random_percent_check(20): await scare_pkm(get_opp(plr),true)
	else : return
	await wait(2)

func end_turn_effect_activation(plr : int, effect : String):
	var pkm = get_active_pokemon(plr)
	if effect == "Frénésie" && pkm.Statut.has("Frénésie"):
		pkm.Statut.erase("Frénésie")
	elif effect == "Entrave" && pkm.Statut.has("Entrave"):
		EntraveCounter[plr-1] -= 1
		if EntraveCounter[plr-1] <= 0:
			pkm.Statut.erase("Entrave")
			if plr == 1: await action_ui_writing("La capacité %s de %s n'est plus sous entrave !" % [EntraveAttack[plr-1],get_pkm_nickname(pkm)])
			else : await action_ui_writing("La capacité %s du %s ennemi n'est plus sous entrave !" % [EntraveAttack[plr-1],get_pkm_nickname(pkm)])
	elif effect == "Brume" && BrumeCounter[plr-1] > 0:
		BrumeCounter[plr-1] -= 1
		if BrumeCounter[plr-1] == 0:
			if plr == 1: await action_ui_writing("La brume n'enveloppe plus votre équipe !")
			else : await action_ui_writing("La brume n'enveloppe plus l'équipe ennemie !")
	elif effect == "Apeuré" && pkm.Statut.has("Apeuré"):
		pkm.Statut.erase("Apeuré")
	elif effect == "Brûlé" && pkm.Statut.has("Brûlé"):
		var dmg = round(stat(pkm,"PV")/16)#Inflige 1/16 de la vie
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Burned.mp3")
		Audios.Attack.playing = true
		if plr == 1: await action_ui_writing("%s souffre de la brûlure !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi souffre de la brûlure !" % get_pkm_nickname(pkm))
		await wait(1)
		await damage_animation(plr,dmg,1)
		await wait(1)
	elif effect == "Empoisonné" && pkm.Statut.has("Empoisonné"):
		var dmg = round(stat(pkm,"PV")/8)#Inflige 1/8 de la vie
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Poisoned.mp3")
		Audios.Attack.playing = true
		if plr == 1: await action_ui_writing("%s souffre du poison !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi souffre du poison !" % get_pkm_nickname(pkm))
		await wait(1)
		await damage_animation(plr,dmg,1)
		await wait(1)
	elif effect == "Empoisonné Gravement"  && pkm.Statut.has("Empoisonné Gravement"):
		ToxikCounter[plr-1] += 1
		var dmg = round(ToxikCounter[plr-1]/16.0*stat(pkm,"PV"))
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Poisoned.mp3")
		Audios.Attack.playing = true
		if plr == 1: await action_ui_writing("%s souffre du poison !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Le %s ennemi souffre du poison !" % get_pkm_nickname(pkm))
		await wait(1)
		await damage_animation(plr,dmg,1)
		await wait(1)
	elif effect == "Vampigraine" && pkm.Statut.has("Vampigraine"):
		var dmg = round(stat(pkm,"PV")/8)#Drain 1/8 de la vie
		Audios.Attack.stream = load("res://Sounds/SFX/Damages/VampigraineDamage.mp3")
		Audios.Attack.playing = true
		if plr == 1: await action_ui_writing("Vampigraine draine l'énergie de %s !" % get_pkm_nickname(pkm))
		else : await action_ui_writing("Vampigraine draine l'énergie du %s ennemi !" % get_pkm_nickname(pkm))
		await wait(1)
		await damage_animation(plr,dmg,1)
		await wait(1)
		if Clones[get_opp(plr)-1] == null:
			await damage_animation(get_opp(plr),-dmg,1)
		else:
			var lanceur
			if get_opp(plr) == 1: lanceur = ClientDeck[ClientPokemon]
			else: lanceur = OppDeck[OppPokemon]
			lanceur.Damages -= dmg
			if lanceur.Damages < 0:
				lanceur.Damages = 0
		await wait(1)
	elif effect == "Danse-Flammes" && pkm.Statut.has("Danse-Flammes"):
		if DanseFlammeCounter[plr-1] == 0:
			pkm.Statut.erase("Danse-Flammes")
			if plr == 1: await action_ui_writing("%s n'est plus affecté par la capacité Danse-Flammes" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi n'est plus affecté par la capacité Danse-Flammes" % get_pkm_nickname(pkm))
			await wait(1)
		else :
			DanseFlammeCounter[plr-1] -= 1
			var dmg = round(stat(pkm,"PV")/8)#Inflige 1/8 de la vie
			Audios.Attack.stream = load("res://Sounds/SFX/Damages/Danse-FlammesDamage.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s est blessé par la capacité Danse-Flammes !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est blessé par la capacité Danse-Flammes !" % get_pkm_nickname(pkm))
			await wait(1)
			await damage_animation(plr,dmg,1)
			await wait(1)
	elif effect == "Ligotage" && pkm.Statut.has("Ligotage"):
		if LigotageCounter[plr-1] == 0:
			pkm.Statut.erase("Ligotage")
			if plr == 1: await action_ui_writing("%s n'est plus affecté par la capacité Ligotage" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi n'est plus affecté par la capacité Ligotage" % get_pkm_nickname(pkm))
			await wait(1)
		else :
			LigotageCounter[plr-1] -= 1
			var dmg = round(stat(pkm,"PV")/8)#Inflige 1/8 de la vie
			Audios.Attack.stream = load("res://Sounds/SFX/Damages/LigotageDamage.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s est blessé par la capacité Ligotage !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est blessé par la capacité Ligotage !" % get_pkm_nickname(pkm))
			await wait(1)
			await damage_animation(plr,dmg,1)
			await wait(1)
	elif effect == "Mur Lumière" && MurLumiereCounter[plr-1] > 0:
		MurLumiereCounter[plr-1] -= 1
		if MurLumiereCounter[plr-1] == 0:
			if plr == 1: await action_ui_writing("Mur Lumière n'augmente plus la résistance de l'équipe aux capacités spéciales !")
			else : await action_ui_writing("Mur Lumière n'augmente plus la résistance de l'équipe ennemie aux capacités spéciales !")
			await wait(1)
	elif effect == "Protection" && ProtectionCounter[plr-1] > 0:
		ProtectionCounter[plr-1] -= 1
		if ProtectionCounter[plr-1] == 0:
			if plr == 1: await action_ui_writing("Protection n'augmente plus la résistance de l'équipe aux capacités physiques !")
			else : await action_ui_writing("Protection n'augmente plus la résistance de l'équipe ennemie aux capacités physiques !")
			await wait(1)
	elif effect == "Claquoir" && pkm.Statut.has("Claquoir"):
		if ClaquoirCounter[plr-1] == 0:
			pkm.Statut.erase("Claquoir")
			if plr == 1: await action_ui_writing("%s n'est plus affecté par la capacité Claquoir" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi n'est plus affecté par la capacité Claquoir" % get_pkm_nickname(pkm))
			await wait(1)
		else :
			ClaquoirCounter[plr-1] -= 1
			var dmg = round(stat(pkm,"PV")/8)#Inflige 1/8 de la vie
			Audios.Attack.stream = load("res://Sounds/SFX/Attack/Claquoir.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s est blessé par la capacité Claquoir !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est blessé par la capacité Claquoir !" % get_pkm_nickname(pkm))
			await wait(1)
			await damage_animation(plr,dmg,1)
			await wait(1)
	elif effect == "Étreinte" && pkm.Statut.has("Étreinte"):
		if EtreinteCounter[plr-1] == 0:
			pkm.Statut.erase("Étreinte")
			if plr == 1: await action_ui_writing("%s n'est plus affecté par la capacité Étreinte" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi n'est plus affecté par la capacité Étreinte" % get_pkm_nickname(pkm))
			await wait(1)
		else :
			EtreinteCounter[plr-1] -= 1
			var dmg = round(stat(pkm,"PV")/8)#Inflige 1/8 de la vie
			Audios.Attack.stream = load("res://Sounds/SFX/Damages/ÉtreinteDamage.mp3")
			Audios.Attack.playing = true
			if plr == 1: await action_ui_writing("%s est blessé par la capacité Étreinte !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("Le %s ennemi est blessé par la capacité Étreinte !" % get_pkm_nickname(pkm))
			await wait(1)
			await damage_animation(plr,dmg,1)
			await wait(1)

func switch(plr : int, from : Dictionary, to : int):
	var pkm
	var ball = get_nodes(plr).Pokeball
	var sprite = get_nodes(plr).Sprite
	var time = 0.7
	var divisions = FPS
	reset_modifs(plr)
	from.Statut.erase("Lilliput")
	Charging[plr-1] = ""
	MimiqueAttack = ["",""]
	EntraveAttack[plr-1] = ""
	EntraveCounter[plr-1] = 0
	DanseFlammeCounter[plr-1] = 0
	ToxikCounter[plr-1] = 0
	LigotageCounter[plr-1] = 0
	ClaquoirCounter[plr-1] = 0
	EtreinteCounter[plr-1] = 0
	LockCounter[plr-1] = 0
	if InitalMetamorphs[plr-1] != null:
		await unmorph_animation(plr)
	InitalMetamorphs[plr-1] = null
	MimicStun[plr-1] = false
	ClientNodes.Block.visible = false
	OppNodes.Block.visible = false
	if plr == 1: pkm = ClientDeck[to]
	else: pkm = OppDeck[to]
	if Clones[plr-1] != null: await clone_disapear_animation(plr)
	Clones[plr-1] = null
	if from.Statut.has("Claquoir"):
		pkm.Statut.append("Claquoir")
	if from.Damages < stat(from,"PV"):
		ball.visible = true
		ball.z_index = 1
		sprite.material.set_shader_parameter('spawn_anim',3)
		ball.rotation = 0
		ball.frame_coords.y = 3
		Audios.SFX.stream = load("res://Sounds/SFX/Pokemon/%s.ogg" % from.Name)
		Audios.SFX.playing = true
		await action_ui_writing("%s reviens !" % get_pkm_nickname(from))
		Audios.Attack.stream = load("res://Sounds/SFX/Other/Reviens.mp3")
		Audios.Attack.playing = true
		var open_timing = 0.0
		for i in range(divisions+1,1,-1):
			ball.frame_coords.y = 3+floor(i/divisions*11)
			if ball.frame_coords.y==7:
				open_timing = i
			if ball.frame_coords.y>=7:
				sprite.material.set_shader_parameter('spawn_anim', (i-open_timing)/(divisions-open_timing)*3.0)
			await wait(time/divisions)
		ball.visible = false
		ball.z_index = 0
		await wait(1.5)
	await pokemon_activation(plr,to)
	refresh_ui()

func pokemon_fainted(plr : int):
	var time = 0.2
	var divisions = FPS
	var pkm = get_active_pokemon(plr)
	var node = get_nodes(plr).Sprite
	get_active_pokemon(plr).Statut.clear()
	if plr == 1:
		ClientNodes.Block.visible = false
		SleepCounter[ClientPokemon] = 0
		ConfuseCounter[ClientPokemon] = 0
	else :
		OppNodes.Block.visible = false
		SleepCounter[OppPokemon+6] = 0
		ConfuseCounter[OppPokemon+6] = 0
	reset_modifs(plr)
	Charging[plr-1] = ""
	MimiqueAttack = ["",""]
	EntraveAttack[plr-1] = ""
	EntraveCounter[plr-1] = 0
	DanseFlammeCounter[plr-1] = 0
	ToxikCounter[plr-1] = 0
	LigotageCounter[plr-1] = 0
	ClaquoirCounter[plr-1] = 0
	EtreinteCounter[plr-1] = 0
	LockCounter[plr-1] = 0
	if InitalMetamorphs[plr-1] != null:
		await unmorph_animation(plr)
	InitalMetamorphs[plr-1] = null
	MimicStun[plr-1] = null
	Audios.SFX.stream = load("res://Sounds/SFX/Damages/Mort.mp3")
	Audios.SFX.playing = true
	for i in range(divisions):
		node.material.set_shader_parameter('death_animation', i/divisions*100)
		await wait(time/divisions)
	node.texture = null
	node.material.set_shader_parameter('death_animation', 0)
	await wait(0.5)
	if plr == 1: await action_ui_writing("%s est mis K.O. !" % get_pkm_nickname(pkm))
	else : await action_ui_writing("Le %s ennemi est mis K.O. !" % get_pkm_nickname(pkm))
	await wait(1)

func pokemon_activation(plr : int, number : int):
	var node = get_nodes(plr).Sprite
	var ball = get_nodes(plr).Pokeball
	var time = 0.7
	var divisions = FPS
	if plr == 1: ClientPokemon = number
	else: OppPokemon = number
	var pkm = get_active_pokemon(plr)
	if plr == 1: node.texture = load(get_pokemon_img("Back",pkm.Name,ClientDeck[ClientPokemon].Shiny))
	else: node.texture = load(get_pokemon_img("Front",pkm.Name,OppDeck[OppPokemon].Shiny))
	if !participants_KO_exp.has(ClientPokemon) && against_bot: participants_KO_exp.append(ClientPokemon)
	status_animation()
	ball.visible = true
	node.material.set_shader_parameter('spawn_anim',0)
	ball.rotation = 0
	ball.frame_coords.y = 3
	await action_ui_writing("%s envoie %s !" % [Joueurs[plr-1],get_pkm_nickname(pkm)])
	var open_timing = 0.0
	Audios.Attack.stream = load("res://Sounds/SFX/Other/Apparition.mp3")
	Audios.Attack.playing = true
	for i in range(1,divisions+1):
		ball.frame_coords.y = 3+floor(i/divisions*11)
		if ball.frame_coords.y==7:
			open_timing = i
		if ball.frame_coords.y>=7:
			node.material.set_shader_parameter('spawn_anim', (i-open_timing)/(divisions-open_timing)*3.0)
		await wait(time/divisions)
	ball.visible = false
	Audios.SFX.stream = load("res://Sounds/SFX/Pokemon/%s.ogg" % pkm.Name)
	Audios.SFX.playing = true
	await wait(1.5)
	death_switch = false
	
	
	if allow_death_switch && plr == 1 && OppDeck[OppPokemon].Damages >= stat(OppDeck[OppPokemon],"PV"):
		if against_bot:
			ia_death_switch(2)
			await pokemon_activation(2, int(incomming_attacks[1][-1]))
		else: pass #SI PVP


#									-----ATTACK EFFECTS-----
func change_stat_pkm(plr : int, Stat : String, ChangeValue : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	var iterations = 0
	var positive = ChangeValue > 0
	for i in range(abs(ChangeValue)):
		if positive:
			if Modifs[plr][Stat] < 6:
				iterations += 1
				Modifs[plr][Stat] += 1
		else:
			if Modifs[plr][Stat] > -6:
				iterations += 1
				Modifs[plr][Stat] -= 1
	if iterations == 0 || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	elif BrumeCounter[plr-1] > 0 && from_opponent:
		if miss_text :
			Audios.SFX.stream = load("res://Sounds/SFX/Status/Brume.mp3")
			Audios.SFX.playing = true
			await action_ui_writing("Mais cela échoue...")
	else:
		var msg = ""
		if Stat.begins_with("A") || Stat.begins_with("E"): msg = "L'%s" % Stat
		else: msg = "La %s" % Stat
		if plr == 1: msg += " de %s" % get_pkm_nickname(pkm)
		else: msg += " du %s ennemi" % get_pkm_nickname(pkm)
		msg = msg.replace("Precision","Précision")
		msg = msg.replace("Defense","Défense")
		msg = msg.replace("Spe"," Spéciale")
		if positive:
			modif_stat_animation(plr,true)
			Audios.SFX.stream = load("res://Sounds/SFX/Status/Stat Up.mp3")
			msg += " augmente"
		else:
			modif_stat_animation(plr,false)
			Audios.SFX.stream = load("res://Sounds/SFX/Status/Stat Down.mp3")
			msg += " baisse"
		if iterations == 1: msg += " !"
		else : msg += " beaucoup !"
		Audios.SFX.playing = true
		await action_ui_writing(msg)

func burn_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if a_statut_majeur(pkm) || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		if get_types(pkm).has("Feu"):
			if miss_text : await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Burned.mp3")
			Audios.Attack.playing = true
			pkm.Statut.append("Brûlé")
			status_animation()
			if plr == 1: await action_ui_writing("Le %s ennemi est brûlé !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("%s est brûlé !" % get_pkm_nickname(pkm))

func confuse_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if pkm.Statut.has("Confus") || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Confused.mp3")
		Audios.Attack.playing = true
		pkm.Statut.append("Confus")
		status_animation()
		if plr == 1:
			ConfuseCounter[ClientPokemon] = randi_range(1,4)
			await action_ui_writing("%s est confus !" % get_pkm_nickname(pkm))
		else :
			ConfuseCounter[OppPokemon+6] = randi_range(1,4)
			await action_ui_writing("Le %s ennemi est confus !" % get_pkm_nickname(pkm))

func sleep_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if a_statut_majeur(pkm) || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Sleep.mp3")
		Audios.Attack.playing = true
		pkm.Statut.append("Endormi")
		status_animation()
		if plr == 1:
			SleepCounter[ClientPokemon] = randi_range(1,3)
			await action_ui_writing("%s s'est endormi !" % get_pkm_nickname(pkm))
		else:
			SleepCounter[OppPokemon+6] = randi_range(1,3)
			await action_ui_writing("Le %s ennemi s'est endormi !" % get_pkm_nickname(pkm))

func poison_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if a_statut_majeur(pkm) || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		if get_types(pkm).has("Acier") || get_types(pkm).has("Poison"):
			if miss_text : await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Poisoned.mp3")
			Audios.Attack.playing = true
			pkm.Statut.append("Empoisonné")
			status_animation()
			if plr == 1:await action_ui_writing("%s est empoisonné !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi est empoisonné !" % get_pkm_nickname(pkm))

func deep_poison_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if a_statut_majeur(pkm) || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		if get_types(pkm).has("Acier") || get_types(pkm).has("Poison"):
			if miss_text : await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Poisoned.mp3")
			Audios.Attack.playing = true
			pkm.Statut.append("Empoisonné Gravement")
			status_animation()
			if plr == 1:await action_ui_writing("%s est gravement empoisonné !" % get_pkm_nickname(pkm))
			else: await action_ui_writing("Le %s ennemi est gravement empoisonné !" % get_pkm_nickname(pkm))

func paralyse_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if a_statut_majeur(pkm) || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		if get_types(pkm).has("Électrik"):
			if miss_text : await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Paralyzed.mp3")
			Audios.Attack.playing = true
			pkm.Statut.append("Paralysé")
			status_animation()
			if plr == 1:await action_ui_writing("Le %s ennemi est paralysé ! Il aura du mal à attaquer." % get_pkm_nickname(pkm))
			else : await action_ui_writing("%s est paralysé ! Il aura du mal à attaquer." % get_pkm_nickname(pkm))

func froze_pkm(plr : int, miss_text : bool, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if a_statut_majeur(pkm) || (Clones[plr-1] != null && from_opponent):
		if miss_text : await action_ui_writing("Mais cela échoue...")
	else:
		if get_types(pkm).has("Glace"):
			if miss_text : await action_ui_writing("Mais ça ne l'affecte pas...")
		else:
			Audios.Attack.stream = load("res://Sounds/SFX/Status/Status Frozen.mp3")
			Audios.Attack.playing = true
			pkm.Statut.append("Gelé")
			status_animation()
			if plr == 1:await action_ui_writing("Le %s ennemi est gelé !" % get_pkm_nickname(pkm))
			else : await action_ui_writing("%s est gelé !" % get_pkm_nickname(pkm))

func scare_pkm(plr : int, from_opponent : bool):
	var pkm = get_active_pokemon(plr)
	if !(pkm.Statut.has("Apeuré") || !(Clones[plr-1] != null && from_opponent)): pkm.Statut.append("Apeuré")

func reset_modifs(plr : int):
	for modif in Modifs[plr]:
		Modifs[plr][modif] = 0


#									-----CALCULATIONS-----
func damage_calculation(pkm : Dictionary,target : Dictionary,atk : String,crit : bool,weakness : float):
	if atk == "Croc Fatal": return ceil((stat(target,'PV')-target.Damages)/2.0)
	elif atk == "Empal'Korne" || atk == "Guillotine" || atk == "Abîme": return stat(target,'PV')
	elif atk == "Frappe Atlas": return pkm.LvL
	elif atk == "Vague Psy": return pkm.LvL*(randi_range(0,10)+5)/10
	elif atk == "Ombre Nocturne": return pkm.LvL * int(!get_types(pkm).has("Normal"))
	elif atk == "Sonicboom": return 20
	elif atk == "Draco-Rage": return 40
	elif atk == "Riposte" || atk == "Patience": return (pkm.Damages-PreRiposteDamages[pkm.Owner-1])*2
	else:
		var Att = 0
		var Def = 0
		var CM = randf_range(0.85,1) * weakness
		if Stats.ATTACKS[atk].Categorie == "Physique" :
			Att = stat(pkm,"Attaque")
			Def = stat(target,"Defense")
			if pkm.Statut.has("Brûlure") : CM/=2
		elif Stats.ATTACKS[atk].Categorie == "Special" : 
			Att = stat(pkm,"AttaqueSpe")
			Def = stat(target,"DefenseSpe")
		var TypeAtk = Stats.ATTACKS[atk].Type
		if get_types(pkm).has(TypeAtk):
			if atk != "Lutte":
				CM *= 1.5#----------------------------STAB
		var LvL = pkm.LvL
		if crit:
			CM *= 1.5#------------------CRIT
		var Pui = Stats.ATTACKS[atk].Puissance
		if atk == "Balayage":
			var pds = Stats.POKEMONS[target.Name].Poids
			if pds <= 9.9: Pui = 20
			elif pds <= 24.9: Pui = 40
			elif pds <= 49.9: Pui = 60
			elif pds <= 99.9: Pui = 80
			elif pds <= 199.9: Pui = 100
			else : Pui = 120
		if Charging.has("Vol") && atk=="Tornade": Pui *= 2.0
		if Charging.has("Tunnel") && atk=="Séisme": Pui *= 2.0
		if atk=="Destruction": Def /= 2.0
		if atk == "Écrasement" && target.Statut.has("Lilliput"): Pui *= 2.0
		var damages = round((((((LvL*0.4+2)*Att*Pui)/Def)/50)+2)*CM)
		if atk == "Plaquage" && target.Statut.has("Lilliput"): damages*=2.0
		return damages

func weakness_calculation(atk : String,target : Dictionary):
	var TypeAtk = Stats.ATTACKS[atk].Type
	var Types = get_types(target)
	var R = 1.0
	if Types[0] != null: R *= weak_check(TypeAtk,Types[0])
	if Types[1] != null: R *= weak_check(TypeAtk,Types[1])
	if atk == "Lutte" && (Types.has("Roche") || Types.has("Acier")): R = 0.0
	return R

func precision_calculation(pkm : Dictionary,target : Dictionary,atk : String):
	var Pre = Stats.ATTACKS[atk].Precision
	if atk == "Empal'Korne" || atk == "Guillotine" || atk == "Abîme":
		return random_percent_check((pkm.LvL - target.LvL) + 30)
	elif (atk == "Plaquage" || atk == "Écrasement") && target.Statut.has("Lilliput"):
		return true
	elif Pre == null:
		return true
	else:
		var PreA2 = stat(pkm,"Precision")
		var EsqB = stat(target,"Esquive")
		return random_percent_check(Pre * PreA2 / EsqB)

func first_pick_calculation():
	var atk1 = Stats.ATTACKS.get(incomming_attacks[0])
	var prio1 = 0
	if atk1 == null:
		if incomming_attacks[0].begins_with("Switch"): prio1 = 6
	else:
		prio1 = atk1.Priorite
	var atk2 = Stats.ATTACKS.get(incomming_attacks[1])
	var prio2 = 0
	if atk2 == null:
		if incomming_attacks[1].begins_with("Switch"): prio2 = 6
	else:
		prio2 = atk2.Priorite
	if prio1 == prio2:
		var vit1 = stat(ClientDeck[ClientPokemon],"Vitesse")
		var vit2 = stat(OppDeck[OppPokemon],"Vitesse")
		return vit1 > vit2
	else:
		return prio1 > prio2

func lvl_up_calculation(pkm : Dictionary):
	var current_lvl = pkm.LvL
	var targeted_lvl = current_lvl
	while current_lvl == targeted_lvl:
		targeted_lvl += 1
		var required_exp = Stats.max_exp_calculation(pkm,targeted_lvl)
		if pkm.EXP >= required_exp:
			pkm.EXP -= required_exp
			ClientNodes.ExpBar.value = pkm.EXP
			current_lvl += 1
	return current_lvl


#									-----IA-----
func ia_moves(plr : int):
	if Charging[plr-1] != "":
		incomming_attacks[plr-1] = Charging[plr-1]
	elif get_active_pokemon(2).Statut.has("Ultralaser"):
		incomming_attacks[plr-1] = "Ultralaser"
	elif LockCounter[plr-1] != 0 || MimicStun[plr-1] == true: incomming_attacks[plr-1] = incomming_attacks[plr-1]
	else:
		IA.possible_moves = []
		ia_attack_list(plr)
		ia_switch_list(plr)
		if IA.possible_moves == []: incomming_attacks[plr-1] = "Lutte"
		else:
			var res = IA.play(game_state)
			if res.begins_with("Switch "):
				res = "Switch %s" % ia_find_pokemon_index(plr, res.split(" ")[1])
			incomming_attacks[plr-1] = res
func ia_death_switch(plr : int):
	game_state = ia_create_game_state()
	IA.possible_moves = []
	ia_switch_list(plr)
	var res = IA.play(game_state)
	incomming_attacks[1] = "Switch %s" % ia_find_pokemon_index(plr, res.split(" ")[1])
func ia_find_pokemon_index(plr : int, pkm_name : String):
	var deck = get_deck(plr)
	for i in range(len(deck)):
		if deck[i].Name == pkm_name:
			return i
func ia_attack_list(plr : int):
	var attack_list = get_active_pokemon(plr).Attacks
	for i in range(len(attack_list)):
		if can_use_move(plr,"Attaque",i):
			IA.possible_moves.append(attack_list[i].Name)
func ia_switch_list(plr : int):
	var deck = get_deck(plr)
	for i in range(len(deck)):
		if can_use_move(plr,"Switch",i):
			IA.possible_moves.append("Switch %s" % deck[i].Name)
func ia_create_game_state():
	var gs = {}
	var pkm_func = func(pkm):
		var r = {}
		r["Name"]=pkm.Name
		r["Max_Hp"]=stat(pkm,"PV")
		r["Hp"]=r["Max_Hp"]-pkm.Damages
		r["Statut"]=pkm.Statut
		r["Speed"]=stat(pkm,"Vitesse")
		return r
	var move_func = func(plr : int):
		var move = incomming_attacks[-1]
		if move == null : return null
		var r = {}
		var target = get_active_pokemon(get_opp(plr))
		if move.begins_with("Switch"):
			var index = move[-1]
			var deck = get_deck(plr)
			var pkm = deck[int(index)]
			r["Name"] = move.replace(index,pkm.Name)
			var p_types = get_types(pkm)
			var t_types = get_types(target)
			r["Efficiency"] = weak_check(p_types[0],t_types[0])
			if p_types[1] != null: r["Efficiency"] *= weak_check(p_types[1],t_types[0])
			if t_types[1] != null:
				r["Efficiency"] *= weak_check(p_types[0],t_types[1])
				if p_types[1] != null: r["Efficiency"] *=  weak_check(p_types[1],t_types[1])
		else:
			r["Name"] = move
			r["Efficiency"] = weakness_calculation(move,target)
		return r
	
	gs["IA"] = {}
	gs["IA"]["Active"] = pkm_func.call(get_active_pokemon(2))
	gs["IA"]["Last_Move"] = move_func.call(2)
	
	gs["Opp"] = {}
	gs["Opp"]["Active"] = pkm_func.call(get_active_pokemon(1))
	gs["Opp"]["Last_Move"] = move_func.call(2)
	
	gs["Modifs"]=Modifs
	return gs


#									  -----CHECKS-----
func random_percent_check(percent : float):
	return randf_range(0.00,99.00) <= percent

func crit_check(plr : int):
	var atk = incomming_attacks[plr-1]
	var crit = Stats.ATTACKS[atk].Critique+Modifs[plr].get("Critique")
	if crit > 5 : crit = 5
	return random_percent_check(Stats.CRIT_OCCUR[crit]*100.0)

func weak_check(TypeA : String, TypeB : String):
	#Type A -> Atk
	#Type B -> Subit
	if Stats.TABLE_TYPE[TypeA].has(TypeB):
		return Stats.TABLE_TYPE[TypeA][TypeB]
	else:
		return 1.0

func check_win():
	win_condition = "Fuite"
	if incomming_attacks[0] == "Fuite" : return 2
	elif incomming_attacks[1] == "Fuite" : return 1
	win_condition = "K.O."
	var p1 = len(get_alive_pokemons(ClientDeck))
	var p2 = len(get_alive_pokemons(OppDeck))
	if p1 == 0 && p2 == 0: return 3
	elif p1 == 0: return 2
	elif p2 == 0: return 1
	
	#SI LE POKEMON EST ATTRAPE
	#win_condition = "Attrapé"
	
	win_condition = null
	return 0

func ingame_check_death():
	if ClientNodes.HealthBar.value == 0 && Fainted[0]==false:
		Fainted[0] = true
		await pokemon_fainted(1)
	if OppNodes.HealthBar.value == 0 && Fainted[1]==false:
		Fainted[1] = true
		await pokemon_fainted(2)
		if against_bot: await XP_phase()
	return (ClientNodes.HealthBar.value == 0 || OppNodes.HealthBar.value == 0)

func a_statut_majeur(pkm : Dictionary):
	return (pkm.Statut.has("Empoisonné") || pkm.Statut.has("Empoisonné Gravement") || pkm.Statut.has("Endormi") || pkm.Statut.has("Paralysé") ||  pkm.Statut.has("Brûlé") || pkm.Statut.has("Gelé"))

func can_use_move(plr : int, move : String, i : int):
	if move == "Switch":
		var deck = get_deck(plr)
		var number
		if plr==1:number=ClientPokemon
		else:number=OppPokemon
		var MaxHealth = stat(deck[i],"PV")
		return i!=number && deck[i].Damages<MaxHealth && DanseFlammeCounter[plr-1]==0 && LigotageCounter[plr-1]==0
	elif move == "Attaque":
		var atk = get_active_pokemon(plr).Attacks[i]
		return atk.PP>0 && !(EntraveAttack[plr-1]==atk.Name && EntraveCounter[plr-1]>0)


#									  -----ANIMATIONS-----
func reset_ui():
	MainUI.MainMenu.visible = false
	MainUI.AtkMenu.visible = false
	MainUI.PkmMenu.visible = false
	DeathSwitchUI.Block.visible = false
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
	ClientNodes.Pokeball.position = ClientNodes.Sprite.position+Vector2(0,100)
	OppNodes.Pokeball.position = OppNodes.Sprite.position+Vector2(0,100)
	decoration_setup()

func refresh_ui():
	decoration_setup()
	for plr in range(1,3):
		var nodes = get_nodes(plr)
		if len(get_deck(plr)) > 0:
			var pkm = get_active_pokemon(plr)
			var MaxHealth = stat(pkm,"PV")
			var Health = MaxHealth - pkm.Damages
			nodes.Name.text = get_pkm_nickname(pkm)
			if pkm.Shiny == 's': nodes.Name.text += "☆"
			nodes.LvL.text = "Lv.%s" % pkm.LvL
			nodes.HealthBar.max_value = MaxHealth
			nodes.HealthBar.value = Health
			if Health <= MaxHealth/10.0: nodes.HealthBar["theme_override_styles/fill"].bg_color = Color(1,0,0)
			elif Health <= MaxHealth/2.0: nodes.HealthBar["theme_override_styles/fill"].bg_color = Color(1,1,0)
			else: nodes.HealthBar["theme_override_styles/fill"].bg_color = Color(0,1,0)
			nodes.HealthLabel.text = "%s / %s" % [Health,MaxHealth]
			nodes.Block.visible = true
			if plr == 1:
				nodes.Sprite.texture = load(get_pokemon_img("Back",pkm.Name,pkm.Shiny))
				nodes.ExpBar.max_value = Stats.max_exp_calculation(pkm,pkm.LvL+1)
				nodes.ExpBar.value = pkm.EXP
			else: nodes.Sprite.texture = load(get_pokemon_img("Front",pkm.Name,pkm.Shiny))
			status_animation()

func decoration_setup():
	if decoration == "Plaine":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(240,255,255))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(90,150,39))
	elif decoration == "Forêt":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(29,180,114))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(25,47,7))
	elif decoration == "Grotte":
		#$Sprites/Background.material.set_shader_parameter('color1', Color8(132,103,52))
		#$Sprites/Background.material.set_shader_parameter('color2', Color8(54,41,14))
		$Sprites/Background.material.set_shader_parameter('color1', Color8(193,159,51))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(52,49,37))
	elif decoration == "Plage":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(50,187,248))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(283,188,101))
	elif decoration == "Lac":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(79,111,58))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(35,117,137))
	elif decoration == "Mer":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(0,150,255))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(20,70,255))
	elif decoration == "Forêt Mystique":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(134,40,239))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(25,47,7))
	elif decoration == "Labo":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(133,167,200))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(193,213,226))
	elif decoration == "Dojo":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(214,146,83))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(224,203,172))
	elif decoration == "Mont":
		$Sprites/Background.material.set_shader_parameter('color1', Color8(233,255,255))
		$Sprites/Background.material.set_shader_parameter('color2', Color8(19,184,125))

func attack_animation(plr : int,atk : String):
	var pkm = get_nodes(plr).Sprite
	var s = 0
	if plr == 1: s = 1
	else : s = -1
	Audios.Attack.stream = load("res://Sounds/SFX/Attack/%s.mp3" % atk)
	Audios.Attack.playing = true
	await wait(0.2)
	####################################################################
	####################################################################
	#Placer ici l'animation spécifique pour l'attaque (utiliser atk => nom de la capa)
	#en attendant, l'anim de Charge est donnée pour toutes les attaques
	####################################################################
	####################################################################
	var clone_exchange = Clones[plr-1] != null
	if atk == "Clonage":
		if !clone_exchange: await clone_exchange_animation(plr)
	elif atk == "Morphing":
		pass
	else:#Charge (animation par défaut)
		var time = 0.1
		var divisions = FPS
		for i in range(1,divisions+1):
			if i > divisions/2:
				pkm.offset.x -= 10/divisions*s
			else:
				pkm.offset.x += 10/divisions*s
			await wait(time/divisions)
		pkm.offset.x = 0

func clone_disapear_animation(plr : int):
	var pkm = get_nodes(plr).Sprite
	var clone = get_nodes(plr).Clone
	var s = 0
	if plr == 1:
		s = 1
		clone.offset.x = -20
	else :
		s = -1
		clone.offset.x = 0
	pkm.offset.x = -90*s
	clone.visible = true
	var time = 0.1
	var divisions = FPS
	for i in range(1,divisions+1):
		pkm.offset.x += 90/divisions*s
		clone.offset.x -= 90/divisions*s
		await wait(time/divisions)
	clone.visible = false

func clone_exchange_animation(plr : int):
	var pkm = get_nodes(plr).Sprite
	var clone = get_nodes(plr).Clone
	var s = 0
	if plr == 1:
		s = 1
		clone.offset.x = -110
	else :
		s = -1
		clone.offset.x = 90
	pkm.offset.x = 0
	clone.visible = true
	var time = 0.1
	var divisions = FPS
	for i in range(1,divisions+1):
		pkm.offset.x -= 90/divisions*s
		clone.offset.x += 90/divisions*s
		await wait(time/divisions)

func unmorph_animation(plr : int):
	var pkm = get_active_pokemon(plr)
	var target = InitalMetamorphs[plr-1]
	pkm.Nickname = target.Nickname
	pkm.Name = target.Name
	pkm.Shiny = target.Shiny
	pkm.Stats = {
		"PV":{"IV":target.Stats.PV.IV,"EV":target.Stats.PV.EV},
		"Attaque":{"IV":target.Stats.Attaque.IV,"EV":target.Stats.Attaque.EV},
		"Defense":{"IV":target.Stats.Defense.IV,"EV":target.Stats.Defense.EV},
		"AttaqueSpe":{"IV":target.Stats.AttaqueSpe.IV,"EV":target.Stats.AttaqueSpe.EV},
		"DefenseSpe":{"IV":target.Stats.DefenseSpe.IV,"EV":target.Stats.DefenseSpe.EV},
		"Vitesse":{"IV":target.Stats.Vitesse.IV,"EV":target.Stats.Vitesse.EV}}
	pkm.Attacks.clear()
	for ta in target.Attacks: pkm.Attacks.append({"Name":ta.Name,"PP":ta.PP})
	var sprite = get_nodes(plr).Sprite
	sprite.skew = 0
	var time = 0.1
	var divisions = FPS
	for i in range(1,divisions+1):
		sprite.skew += deg_to_rad(89.9/divisions)
		await wait(time/divisions)
	if plr == 1: sprite.texture = load(get_pokemon_img("Back",pkm.Name,pkm.Shiny))
	else: sprite.texture = load(get_pokemon_img("Front",pkm.Name,pkm.Shiny))
	sprite.skew = deg_to_rad(-89.9)
	for i in range(1,divisions+1):
		sprite.skew += deg_to_rad(89.9/divisions)
		await wait(time/divisions)
	sprite.skew = 0
	await wait(1.0)

func morph_animation(plr : int):
	var pkm = get_active_pokemon(plr)
	var sprite = get_nodes(plr).Sprite
	sprite.skew = 0
	var time = 0.1
	var divisions = FPS
	for i in range(1,divisions+1):
		sprite.skew += deg_to_rad(89.9/divisions)
		await wait(time/divisions)
	if plr == 1: sprite.texture = load(get_pokemon_img("Back",pkm.Name,pkm.Shiny))
	else: sprite.texture = load(get_pokemon_img("Front",pkm.Name,pkm.Shiny))
	sprite.skew = deg_to_rad(-89.9)
	for i in range(1,divisions+1):
		sprite.skew += deg_to_rad(89.9/divisions)
		await wait(time/divisions)
	sprite.skew = 0
	await wait(1.0)

func action_ui_writing(text : String):
	var time = 0.02
	ActionUI.Label.text = ""
	for letter in text:
		ActionUI.Label.text += letter
		await wait(time)            #Time -> for one letter
		#await wait(time/len(text)) #Time -> total

func damage_animation(plr : int, damages : int, weak : float, ignore_clone : bool = true):
	var pkm = get_active_pokemon(plr)
	if Clones[plr-1] != null && !ignore_clone: pkm = Clones[plr-1]
	var ui = get_nodes(plr)
	var MaxHealth = stat(pkm,"PV")
	var total_damages = pkm.Damages + damages
	if total_damages >= MaxHealth:# Mort
		total_damages = MaxHealth
	elif total_damages < 0:# Zero Dmg
		total_damages = 0
	var time = 1.0
	var divisions = FPS
	if damages >= 0:
		if weak == 1:
			Audios.Damages.stream = load("res://Sounds/SFX/Damages/Normal.mp3")
		elif weak < 1:
			Audios.Damages.stream = load("res://Sounds/SFX/Damages/Weak.mp3")
		else :
			Audios.Damages.stream = load("res://Sounds/SFX/Damages/Effective.mp3")
	else :
		Audios.Damages.stream = load("res://Sounds/SFX/Damages/Heal.mp3")
	Audios.Damages.playing = true
	if pkm.Name == "Clone":
		if plr == 1 : await action_ui_writing("Le clone subit les dégâts à la place de %s !" % get_pkm_nickname(ClientDeck[ClientPokemon]))
		else : await action_ui_writing("Le clone subit les dégâts à la place du %s ennemi !" % get_pkm_nickname(OppDeck[OppPokemon]))
		await wait(1)
	else:
		for i in range(1,divisions+1):
			ui.Sprite.visible = !floor(i%int(divisions/5)/(divisions/10))#binary code
			var Health = MaxHealth - pkm.Damages
			Health -= damages*i/divisions
			if Health < 0:
				Health = 0
			elif Health > MaxHealth:
				Health = MaxHealth
			ui.HealthBar.value = Health
			if Health <= MaxHealth*0.1: ui.HealthBar["theme_override_styles/fill"].bg_color = Color(1,0,0)
			elif Health <= MaxHealth*0.5: ui.HealthBar["theme_override_styles/fill"].bg_color = Color(1,1,0)
			else: ui.HealthBar["theme_override_styles/fill"].bg_color = Color(0,1,0)
			ui.HealthLabel.text = "%s / %s" % [round(Health),MaxHealth]
			await wait(time/divisions)
	pkm.Damages = total_damages
	if pkm.Name == "Clone":
		if pkm.Damages >= MaxHealth:
			Clones[plr-1] = null
			await action_ui_writing("Le clone disparaît !")
			await clone_disapear_animation(plr)
			await wait(1)
	else:
		if pkm.Damages >= MaxHealth*0.9 && pkm.Damages < MaxHealth:# Low
			Audios.Damages.stream = load("res://Sounds/SFX/Damages/Low.mp3")
			Audios.Damages.playing = true
	await wait(0.2)

func crit_animation():
	ActionUI.Label["theme_override_colors/font_color"] = Color8(255,0,0)
	await action_ui_writing("Coup Critique !")
	await wait(2)

func weakness_animation(weakness : float):
	if weakness >= 2 :
		await action_ui_writing("C'est super efficace !")
	elif weakness == 0 :
		await action_ui_writing("Mais ça ne l'affecte pas...")
	elif weakness <= 0.5 :
		await action_ui_writing("Ce n'est pas très efficace...")
	await wait(2)

func status_animation():
	for plr in range(1,3):
		var pkm = get_active_pokemon(plr)
		var nodes = get_nodes(plr)
		nodes.Sprite.material.set_shader_parameter('is_confused', pkm.Statut.has("Confus"))
		if pkm.Statut.has("Brûlé"):
			nodes.Sprite.material.set_shader_parameter('status', 1)
			nodes.StatutBlock.visible = true
			nodes.StatutTexture.texture = load("res://Textures/Statuts/Brûlé.png")
		elif pkm.Statut.has("Gelé"):
			nodes.Sprite.material.set_shader_parameter('status', 2)
			nodes.StatutBlock.visible = true
			nodes.StatutTexture.texture = load("res://Textures/Statuts/Gelé.png")
		elif pkm.Statut.has("Paralysé"):
			nodes.Sprite.material.set_shader_parameter('status', 3)
			nodes.StatutBlock.visible = true
			nodes.StatutTexture.texture = load("res://Textures/Statuts/Paralysé.png")
		elif pkm.Statut.has("Empoisonné"):
			nodes.Sprite.material.set_shader_parameter('status', 4)
			nodes.StatutBlock.visible = true
			nodes.StatutTexture.texture = load("res://Textures/Statuts/Empoisonné.png")
		elif pkm.Statut.has("Endormi"):
			nodes.Sprite.material.set_shader_parameter('status', 5)
			nodes.StatutBlock.visible = true
			nodes.StatutTexture.texture = load("res://Textures/Statuts/Endormi.png")
		elif pkm.Statut.has("Empoisonné Gravement"):
			nodes.Sprite.material.set_shader_parameter('status', 6)
			nodes.StatutBlock.visible = true
			nodes.StatutTexture.texture = load("res://Textures/Statuts/Empoisonné Grave.png")
		else :
			nodes.Sprite.material.set_shader_parameter('status', 0)
			nodes.StatutBlock.visible = false

func exp_animation(pkm : Dictionary, EXP : float):
	pkm.EXP += EXP
	var is_active = (pkm == get_active_pokemon(pkm.Owner))
	await action_ui_writing("%s a gagné %s EXP !" % [get_pkm_nickname(pkm),EXP])
	await wait(1)
	var LvL = lvl_up_calculation(pkm)
	var time = 1.0
	var divisions = FPS
	if is_active:
		for i in range(1,divisions+1):
			var exp_val = pkm.EXP - EXP
			exp_val += EXP*i/divisions
			ClientNodes.ExpBar.value = exp_val
			await wait(time/divisions)
	if LvL > pkm.LvL:
		if is_active : ClientNodes.LvL.text = "Lv.%s" % pkm.LvL
		pkm.LvL = LvL
		Audios.SFX.stream = load("res://Sounds/SFX/Other/LvLup.mp3")
		Audios.SFX.playing = true
		await action_ui_writing("%s passe Lv.%s !" % [get_pkm_nickname(pkm),str(LvL)])
		await wait(1)

func modif_stat_animation(plr : int, raise : bool):
	var sprite = get_nodes(plr).Sprite
	var time = 1.0
	var divisions = FPS
	sprite.material.set_shader_parameter('is_raise', raise)
	for i in range(1,divisions+1):
		sprite.material.set_shader_parameter('raise_alpha', sin(i/divisions*PI)*200)
		await wait(time/divisions)


func wait(time : float):
	await get_tree().create_timer(time).timeout


#									  -----BUTTONS-----
func enter_attack(a):
	Audios.Button.playing = true
	var a_name = ClientDeck[ClientPokemon].Attacks[a].Name
	incomming_attacks[0] = a_name
	if against_bot == true:
		attack_phase()

func change_pokemon(a):
	Audios.Button.playing = true
	pokemon_unhover()
	incomming_attacks[0] = "Switch %s" % a
	if against_bot == true:
		if death_switch : 
			MainUI.PkmMenu.visible = false
			MainUI.PkmBack.visible = true
			DeathSwitchUI.Block.visible = false
			await wait(1)
			await switch_phase(first_pick_calculation())
			await wait(1)
			preparation_phase()
		else : attack_phase()

func pokemon_hover(a):
	if a+1 <= len(ClientDeck):
		var pkm = ClientDeck[a]
		PkmInfoUI.Name.text = get_pkm_nickname(pkm)
		if pkm.Nickname != null:
			PkmInfoUI.Name.text += " (%s)" % pkm.Name
		PkmInfoUI.LvL.text = "Lv. %s" % pkm.LvL
		var MaxHealth = stat(pkm,"PV")
		var Health = MaxHealth-pkm.Damages
		PkmInfoUI.HealthBar.max_value = MaxHealth
		PkmInfoUI.HealthBar.value = Health
		if Health <= MaxHealth*0.1: PkmInfoUI.HealthBar["theme_override_styles/fill"].bg_color = Color(1,0,0)
		elif Health <= MaxHealth*0.5: PkmInfoUI.HealthBar["theme_override_styles/fill"].bg_color = Color(1,1,0)
		else: PkmInfoUI.HealthBar["theme_override_styles/fill"].bg_color = Color(0,1,0)
		PkmInfoUI.Health.text = "%s / %s" % [Health,MaxHealth]
		var attack_list = pkm.Attacks
		for i in range(1,5):
			if i <= len(attack_list):
				var atk = attack_list[i-1]
				PkmInfoUI["Atk%s" % i].text = "%s (%s/%s)" % [atk.Name,atk.PP,Stats.ATTACKS[atk.Name].PP]
			else:
				PkmInfoUI["Atk%s" % i].text = ""
		if Health <= 0:
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/K.O..png")
		elif pkm.Statut.has("Brûlé"):
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/Brûlé.png")
		elif pkm.Statut.has("Gelé"):
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/Gelé.png")
		elif pkm.Statut.has("Paralysé"):
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/Paralysé.png")
		elif pkm.Statut.has("Empoisonné"):
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/Empoisonné.png")
		elif pkm.Statut.has("Empoisonné Gravement"):
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/Empoisonné Grave.png")
		elif pkm.Statut.has("Endormi"):
			PkmInfoUI.Statut.texture = load("res://Textures/Statuts/Endormi.png")
		else :
			PkmInfoUI.Statut.texture = null
		PkmInfoUI.Block.visible = true

func pokemon_unhover():
	PkmInfoUI.Block.visible = false

func _on_attack_pressed():
	var use_lutte = true
	Audios.Button.playing = true
	MainUI.MainMenu.find_child("Attack").disabled = true
	MainUI.MainMenu.find_child("Pokemon").disabled = true
	MainUI.MainMenu.find_child("Objet").disabled = true
	var VBox = MainUI.AtkMenu.find_child("Margin").find_child("HBox").find_child("Attacks").find_child("VBox")
	var attack_list = ClientDeck[ClientPokemon].Attacks
	for i in range(4):
		var Child = VBox.find_child("Attack%s" % str(i+1))
		if i < len(attack_list):
			var Name = attack_list[i].Name
			Child.text = "%s (%s/%s)" % [Name,attack_list[i].PP,Stats.ATTACKS[Name].PP]
			Child.icon = load("res://Textures/Types/Expanded/%s.png" % Stats.ATTACKS[Name].Type)
			var color8 = Stats.TYPE_COLOR[Stats.ATTACKS[Name].Type]*0.8
			color8.a8 = 255
			Child["theme_override_styles/normal"].bg_color = color8
			Child["theme_override_styles/normal"].border_color = color8 - Color8(100,100,100,0)
			Child["theme_override_styles/hover"].bg_color = color8 + Color8(50,50,50,0)
			Child["theme_override_styles/hover"].border_color = color8 - Color8(100,100,100,0)
			Child["theme_override_styles/pressed"].bg_color = color8 - Color8(100,100,100,0)
			Child["theme_override_styles/disabled"].bg_color = color8 - Color8(100,100,100,0)
			Child.disabled = !can_use_move(1,"Attaque",i)
			if Child.disabled == false: use_lutte = false
		else:
			Child.text = ""
			var color8 = Stats.TYPE_COLOR["Normal"]
			Child.icon = null
			Child["theme_override_styles/disabled"].bg_color = color8 - Color8(100,100,100,0)
			Child.disabled = true
	if use_lutte:
		incomming_attacks[0] = "Lutte"
		attack_phase()
	else:
		MainUI.AtkMenu.visible = true
func _on_pokemon_pressed():
	if !death_switch : Audios.Button.playing = true
	MainUI.MainMenu.find_child("Attack").disabled = true
	MainUI.MainMenu.find_child("Pokemon").disabled = true
	MainUI.MainMenu.find_child("Objet").disabled = true
	DeathSwitchUI.Switch.disabled = true
	DeathSwitchUI.Continue.disabled = true
	DeathSwitchUI.Block.visible = false
	var VBox = MainUI.PkmMenu.find_child("Margin").find_child("HBox").find_child("Pokemons").find_child("VBox")
	for i in range(6):
		var button = VBox.find_child("L%s" % [floor(i/2.0)+1]).find_child(str(i+1))
		if i < len(ClientDeck):
			var Name = ClientDeck[i].Name
			var Shiny = ClientDeck[i].Shiny
			button.icon = load(get_pokemon_img("Front",Name,Shiny))
			button.disabled = !can_use_move(1,"Switch",i)
		else :
			button.icon = null
			button.disabled = true
	MainUI.PkmMenu.visible = true
func _on_objet_pressed():
	Audios.Button.playing = true
func _on_back_pressed():
	Audios.Button.playing = true
	if MainUI.MainMenu.visible == true:
		MainUI.MainMenu.find_child("Attack").disabled = false
		MainUI.MainMenu.find_child("Pokemon").disabled = false
		MainUI.MainMenu.find_child("Objet").disabled = false
	else :
		DeathSwitchUI.Switch.disabled = false
		DeathSwitchUI.Continue.disabled = false
		DeathSwitchUI.Block.visible = true
	MainUI.AtkMenu.visible = false
	MainUI.PkmMenu.visible = false
func _on_attack_1_pressed():enter_attack(0)
func _on_attack_2_pressed():enter_attack(1)
func _on_attack_3_pressed():enter_attack(2)
func _on_attack_4_pressed():enter_attack(3)
func _on_pokemon_1_mouse_entered():pokemon_hover(0)
func _on_pokemon_2_mouse_entered():pokemon_hover(1)
func _on_pokemon_3_mouse_entered():pokemon_hover(2)
func _on_pokemon_4_mouse_entered():pokemon_hover(3)
func _on_pokemon_5_mouse_entered():pokemon_hover(4)
func _on_pokemon_6_mouse_entered():pokemon_hover(5)
func _on_pokemon_1_mouse_exited():pokemon_unhover()
func _on_pokemon_2_mouse_exited():pokemon_unhover()
func _on_pokemon_3_mouse_exited():pokemon_unhover()
func _on_pokemon_4_mouse_exited():pokemon_unhover()
func _on_pokemon_5_mouse_exited():pokemon_unhover()
func _on_pokemon_6_mouse_exited():pokemon_unhover()
func _on_pokemon_1_pressed():change_pokemon(0)
func _on_pokemon_2_pressed():change_pokemon(1)
func _on_pokemon_3_pressed():change_pokemon(2)
func _on_pokemon_4_pressed():change_pokemon(3)
func _on_pokemon_5_pressed():change_pokemon(4)
func _on_pokemon_6_pressed():change_pokemon(5)
func _on_switch_pressed():
	Audios.Button.playing = true
	DeathSwitchUI.Switch.disabled = true
	DeathSwitchUI.Continue.disabled = true
	_on_pokemon_pressed()
func _on_continue_pressed():
	Audios.Button.playing = allow_death_switch
	DeathSwitchUI.Block.visible = false
	death_switch = false
	await wait(1)
	if against_bot:
		ia_death_switch(2)
		await pokemon_activation(2, int(incomming_attacks[1][-1]))
		game_state = ia_create_game_state()
		IA.feed(game_state)
		preparation_phase()
	else: pass #SI PVP
