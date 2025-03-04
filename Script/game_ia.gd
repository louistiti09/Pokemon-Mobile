extends Node

#{ état : { action : valeur_Q } }
var q_table = {}
var alpha = 0.1 # Taux apprentissage
var gamma = 0.9 # Facteur discount (importance des récompenses futures)
var espilon = 0.2 # Probabilité d'exploration (0 = exploitation totale, 1 = exploration totale)
var q_table_path = "user://q_table.json"

var gs = {}
var possible_moves = []

# Q-LEARNING
func get_state_key(game_state: Dictionary) -> String:
	var ia_active = game_state["IA"]["Active"]
	var opp_active = game_state["Opp"]["Active"]

	# Calcul des HP en pourcentage, arrondi à 2 décimales
	var ia_hp_percent = round(float(ia_active["Hp"]) / ia_active["Max_Hp"] * 100) / 100
	var opp_hp_percent = round(float(opp_active["Hp"]) / opp_active["Max_Hp"] * 100) / 100

	# Récupération des noms des Pokémon sur le banc et tri
	var bench_names = []
	for pokemon in game_state["IA"]["Bench"]:
		bench_names.append(pokemon["Name"])
	bench_names.sort()
	var bench_str = "-".join(bench_names)

	# Tri des statuts de l'adversaire
	var opp_statuts = game_state["Opp"]["Active"]["Statut"]
	opp_statuts.sort()
	var statuts_str = "-".join(opp_statuts)

	# Convertir les modificateurs en string
	var modifs_ia = []
	var modifs_opp = []
	for key in game_state["Modifs"][1]:
		modifs_ia.append(str(game_state["Modifs"][1][key]))
	for key in game_state["Modifs"][2]:
		modifs_opp.append(str(game_state["Modifs"][2][key]))

	var modifs_ia_str = "_".join(modifs_ia)
	var modifs_opp_str = "_".join(modifs_opp)

	var last_move = null
	if game_state["IA"]["Last_Move"] != null: last_move = game_state["IA"]["Last_Move"]["Name"]

	# Construire la clé en string
	return "%s_%s_%s_%s_%s_%s_%s_%s_%s" % [ia_active["Name"], ia_hp_percent, bench_str, last_move, opp_active["Name"], opp_hp_percent, statuts_str, modifs_ia_str, modifs_opp_str]

func update_q_table(game_state : Dictionary, action : String, reward : int, next_game_state : Dictionary):
	var state_key = get_state_key(game_state)
	var next_state_key = get_state_key(next_game_state)
	
	#Initialisation nouveau game_state
	if !q_table.has(state_key):
		q_table[state_key] = {}
	if !q_table[state_key].has(action):
		q_table[state_key][action] = 0.0
	
	#Calculer nouveau Q
	var max_next_q = 0.0
	if q_table.has(next_state_key): #Vérifier si l'état suivant est connu
		max_next_q = q_table[next_state_key].values().max() #Meilleure valeur Q du prochain état
	
	var old_q = q_table[state_key][action]
	var new_q = old_q + alpha * (reward + gamma * max_next_q - old_q)
	
	q_table[state_key][action] = new_q

func save_q_table():
	var file = FileAccess.open(q_table_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(q_table))
	file.close()

func load_q_table():
	if FileAccess.file_exists(q_table_path):
		var file = FileAccess.open(q_table_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		q_table = JSON.parse_string(content)
		if q_table == null:
			q_table = {}
func _ready():load_q_table()

func get_action(game_state : Dictionary):
	print(game_state["IA"]["Last_Move"]["Name"])
	return game_state["IA"]["Last_Move"]["Name"]

func calculate_reward(old_state : Dictionary, new_state : Dictionary):
	var reward = 0.0
	
	# 1. Bonus/Malus K.O.
	if new_state["Opp"]["Active"]["Hp"] <= 0:
		reward += 50.0 # K.O. Adverse
	if new_state["IA"]["Active"]["Hp"] <= 0:
		reward -= 50.0 # K.O.
		if new_state["IA"]["Last_Move"]["Name"].begins_with("Switch"): reward -= 50.0

	# 2. Dommages infligés et subis
	var damage_dealt = old_state["Opp"]["Active"]["Hp"] - new_state["Opp"]["Active"]["Hp"]
	var damage_taken = old_state["IA"]["Active"]["Hp"] - new_state["IA"]["Active"]["Hp"]
	if !new_state["IA"]["Last_Move"]["Name"].begins_with("Switch"):
		if damage_dealt > 0:
			reward += 50.0 * (damage_dealt / old_state["Opp"]["Active"]["Max_Hp"])
		if damage_taken > 0:
			reward -= 50.0 * (damage_taken / old_state["IA"]["Active"]["Max_Hp"])

	# 3. Efficacité des attaques et switchs
	if new_state["IA"]["Last_Move"]["Efficiency"] > 1:
		reward += 10.0 # Attaque Super Efficace
	elif new_state["IA"]["Last_Move"]["Efficiency"] < 1:
		if new_state["IA"]["Last_Move"]["Name"].begins_with("Switch"):
			reward -= 5.0 # Switch inefficace
		else:
			reward -= 10.0 # Attaque peu efficace

	# 4. Effets de statut (positifs et négatifs)
	var test_statut = func(Folder : String, Statut : String): return new_state[Folder]["Active"]["Statut"].has(Statut) && !old_state[Folder]["Active"]["Statut"].has(Statut)
	var status_rewards = 10.0
	var bad_statuses = ["Brûlé", "Paralysé", "Empoisonné", "Gelé", "Vampigraine", "Danse-Flammes", "Ligotage", "Confus"]
	for status in bad_statuses:
		if test_statut.call("Opp", status): reward += status_rewards # Infliger un statut négatif
		if test_statut.call("IA", status): reward -= status_rewards # Subir un statut négatif

	# 5. Modifications de stats (positives et négatives)
	for Modif in new_state["Modifs"][2]: # Modifs pour l'IA
		var new_Modif = new_state["Modifs"][2][Modif]
		var old_Modif = old_state["Modifs"][2].get(Modif, 0) # Sécurité si la clé n'existe pas
		var diff = new_Modif - old_Modif
		if diff > 0:
			reward += 10.0 * diff # Bonus pour boosts
		else:
			reward -= 10.0 * abs(diff) # Malus pour baisses
	for Modif in new_state["Modifs"][1]: # Modifs pour l'adversaire
		var new_Modif = new_state["Modifs"][1][Modif]
		var old_Modif = old_state["Modifs"][1].get(Modif, 0)
		var diff = new_Modif - old_Modif
		if diff > 0:
			reward -= 10.0 * diff # Malus si l'adversaire se booste
		else:
			reward += 10.0 * abs(diff) # Bonus si l'adversaire est affaibli

	# 6. Prise d'initiative et gestion de la vitesse
	if new_state["IA"]["Active"]["Speed"] > new_state["Opp"]["Active"]["Speed"]:
		reward += 5.0 # Encourager la rapidité
	if new_state["IA"]["Last_Move"]["Name"].begins_with("Switch") and old_state["IA"]["Active"]["Hp"] < old_state["Opp"]["Active"]["Hp"]:
		reward += 5.0 # Bon Switch stratégique

	# 7. Santé du Pokémon IA
	reward += 10.0 * (new_state["IA"]["Active"]["Hp"] / new_state["IA"]["Active"]["Max_Hp"])

	print(reward)
	return reward

func feed(new_state : Dictionary):
	update_q_table(gs, get_action(new_state), calculate_reward(gs,new_state), new_state)

func play(game_state : Dictionary):
	gs = game_state
	var state_key = get_state_key(game_state)
	if randf() < espilon or !q_table.has(state_key):
		#EXPLORATION
		print("EXPLORATION")
		return possible_moves[randi() % possible_moves.size()]
	else:
		#EXPLOITATION
		print("EXPLOITATION")
		var action_values = q_table[state_key]
		var max_value = action_values.values().max()
		var best_actions = []
		for action in action_values:
			if action_values[action] == max_value:
				best_actions.append(action)
		return best_actions[randi() % best_actions.size()]
