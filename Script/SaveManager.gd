extends Node

const EmptyData = {"Pseudo":"","Partenaire":"","Avatar":0,"PlayerLvL":5,"PlayerEXP":0,"Pokemons":[],"CTCS":[],"ActiveTeam":0,"Teams":[{"Team":[],"Name":"Mon Equipe"}]}

func load_data() -> Dictionary:
	if FileAccess.file_exists("user://save_file.json"):
		var file = FileAccess.open("user://save_file.json", FileAccess.READ)
		if file:
			var json_string := file.get_as_text()
			file.close()
			var result = JSON.parse_string(json_string)
			if result is Dictionary:
				print("Data loaded with success !")
				return update_data_version(result)
	return EmptyData

func save_data(data : Dictionary) -> void:
	var json_string := JSON.stringify(data)
	var file = FileAccess.open("user://save_file.json", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Data saved with success !")

func update_data_version(data : Dictionary) -> Dictionary:
	for key in EmptyData.keys():
		if !data.has(key):
			print("Data updated ! (%s added)" % key)
			data[key] = EmptyData[key]
	return data
