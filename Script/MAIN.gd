extends Node

@onready var MAIN = get_node("../MAIN")
#ready -> Title Scene

func change_scene(from : Node2D, to : String, animation : bool = true):
	if MAIN != null:
		if animation:
			pass
		else:
			from.visible = false
			var new_scene = MAIN.get_node(to)
			new_scene.visible = true
			new_scene.call_deferred(to)
	else:
		print("MAIN Scene hasn't been found. Check your launching method.")
