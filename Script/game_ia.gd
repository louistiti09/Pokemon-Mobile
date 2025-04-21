extends Node

#{ état : { action : valeur_Q } }
var q_table = {}
var alpha = 0.1 # Taux apprentissage
var gamma = 0.9 # Facteur discount (importance des récompenses futures)
var epsilon = 0.2 # Probabilité d'exploration (0 = exploitation totale, 1 = exploration totale)
var q_table_path = "user://q_table.json"

var gs = {}
var possible_moves = []

# Q-LEARNING
func get_state_key(game_state: Dictionary) -> String:
	var ia_active = game_state["IA"]["Active"]
	var opp_active = game_state["Opp"]["Active"]
	# Classification des PV
	
	var ia_hp_class = ""
	var PVpct = ia_active["Max_Hp"]/ia_active["Hp"]
	if PVpct < 0.33: ia_hp_class="S"
	elif PVpct < 0.66: ia_hp_class="M"
	else: ia_hp_class="L"
	
	var opp_hp_class = ""  # "S", "M", "L"
	PVpct = opp_active["Max_Hp"]/opp_active["Hp"]
	if PVpct < 0.33: opp_hp_class="S"
	elif PVpct < 0.66: opp_hp_class="M"
	else: opp_hp_class="L"
	
	# Tri des statuts de l'adversaire
	var opp_statuts = opp_active["Statut"]
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
	# Dernier mouvement
	var last_move = null
	if game_state["IA"]["Last_Move"] != null: last_move = game_state["IA"]["Last_Move"]["Name"]
	# Construire la clé en string avec les informations extraites (sans le banc)
	return "%s_%s_%s_%s_%s_%s_%s_%s" % [
		ia_active["Name"], ia_hp_class, last_move, 
		opp_active["Name"], opp_hp_class, statuts_str, modifs_ia_str, modifs_opp_str
	]

func update_q_table(game_state : Dictionary, action : String, reward : float, next_game_state : Dictionary):
	var state_key = get_state_key(game_state)
	var next_state_key = get_state_key(next_game_state)

	ensure_q_entry(state_key, action)

	var max_next_q = 0.0
	if q_table.has(next_state_key):
		var q_values = q_table[next_state_key].values()
		if q_values.size() > 0:
			max_next_q = q_values.max()

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

func ensure_q_entry(state_key: String, action: String) -> void:
	if !q_table.has(state_key):
		q_table[state_key] = {}
	if !q_table[state_key].has(action):
		q_table[state_key][action] = 0.0

func get_action(game_state : Dictionary):
	if game_state["IA"]["Last_Move"] == null: return null
	print(game_state["IA"]["Last_Move"]["Name"])
	return game_state["IA"]["Last_Move"]["Name"]

func calculate_reward(old_state : Dictionary, new_state : Dictionary):
	var reward = 0.0
	
	# 1. K.O.
	if new_state["Opp"]["Active"]["Hp"] <= 0:
		reward += 100.0
	if new_state["IA"]["Active"]["Hp"] <= 0:
		reward -= 100.0
	
	# 2. Dégâts infligés / reçus (normalisés)
	var dmg_dealt = (old_state["Opp"]["Active"]["Hp"] - new_state["Opp"]["Active"]["Hp"]) / old_state["Opp"]["Active"]["Max_Hp"]
	var dmg_taken = (old_state["IA"]["Active"]["Hp"] - new_state["IA"]["Active"]["Hp"]) / old_state["IA"]["Active"]["Max_Hp"]
	reward += 50.0 * clamp(dmg_dealt, 0, 1)
	reward -= 50.0 * clamp(dmg_taken, 0, 1)
	
	# 3. Efficacité
	var eff = new_state["IA"]["Last_Move"]["Efficiency"]
	if eff > 1.0:
		reward += 10.0
	elif eff < 1.0:
		reward -= 10.0
	
	# 4. Switch stratégique
	if new_state["IA"]["Last_Move"]["Name"].begins_with("Switch"):
		if old_state["IA"]["Active"]["Hp"] < old_state["Opp"]["Active"]["Hp"]:
			reward += 10.0 # switch défensif
		else:
			reward -= 5.0 # switch inutile ?
	
	# 5. Statuts infligés / subis
	var bad_statuses = ["Brûlé", "Paralysé", "Empoisonné", "Gelé", "Vampigraine", "Danse-Flammes", "Ligotage", "Confus"]
	for status in bad_statuses:
		if new_state["Opp"]["Active"]["Statut"].has(status) and !old_state["Opp"]["Active"]["Statut"].has(status):
			reward += 15.0
		if new_state["IA"]["Active"]["Statut"].has(status) and !old_state["IA"]["Active"]["Statut"].has(status):
			reward -= 15.0
	
	# 6. Modifs de stats (boosts / baisses)
	# IA boostée
	for k in new_state["Modifs"][2]:
		var delta = new_state["Modifs"][2][k] - old_state["Modifs"][2].get(k, 0)
		reward += delta * 10.0

	# Adversaire affaibli
	for k in new_state["Modifs"][1]:
		var delta = new_state["Modifs"][1][k] - old_state["Modifs"][1].get(k, 0)
		reward -= delta * 10.0
	
	# 7. Initiative (bonus mineur)
	if new_state["IA"]["Active"]["Speed"] > new_state["Opp"]["Active"]["Speed"]:
		reward += 2.0
	
	# 8. Préserver la vie de l'IA (à la fin de l'action)
	var hp_ratio = new_state["IA"]["Active"]["Hp"] / new_state["IA"]["Active"]["Max_Hp"]
	reward += 5.0 * clamp(hp_ratio, 0.0, 1.0)
	
	print(reward)
	return reward

func feed(new_state : Dictionary):
	var action_name = get_action(new_state)
	if action_name != null:
		var reward = calculate_reward(gs, new_state)
		update_q_table(gs, action_name, reward, new_state)

func play(game_state: Dictionary) -> String:
	gs = game_state
	epsilon = max(0.01, epsilon * 0.995) # diminue lentement l'exploration
	var state_key = get_state_key(game_state)

	# On choisit une action (exploration / exploitation)
	if randf() < epsilon or !q_table.has(state_key):
		print("EXPLORATION")
		return possible_moves[randi() % possible_moves.size()]
	else:
		print("EXPLOITATION")
		var best_value = -INF
		var best_actions = []
		for action in possible_moves:
			ensure_q_entry(state_key, action)
			var q = q_table[state_key][action]
			if q > best_value:
				best_value = q
				best_actions = [action]
			elif q == best_value:
				best_actions.append(action)
		return best_actions[randi() % best_actions.size()]
