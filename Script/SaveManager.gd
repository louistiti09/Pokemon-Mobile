extends Node

func load_data() -> Dictionary:
	if FileAccess.file_exists("user://save_file.json"):
		var file = FileAccess.open("user://save_file.json", FileAccess.READ)
		if file:
			var json_string := file.get_as_text()
			file.close()
			var result = JSON.parse_string(json_string)
			if result is Dictionary:
				print("Data loaded with success !")
				return result
	return {}

func save_data(data : Dictionary):
	var json_string := JSON.stringify(data)
	var file = FileAccess.open("user://save_file.json", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("Data saved with success !")
