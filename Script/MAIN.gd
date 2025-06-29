extends Node

#ready -> Title Scene
@onready var MAIN = get_node_or_null("/root/MAIN")

func change_scene(from : Node2D, to : String, animation : bool = true):
	if MAIN != null:
		if animation:
			var Transition = MAIN.get_node_or_null("transition")
			if Transition != null:
				Transition.transition_in()
				await get_tree().create_timer(1.5).timeout
				from.visible = false
				var new_scene = MAIN.get_node(to)
				new_scene.visible = true
				Transition.transition_out()
				new_scene.call_deferred(to)
			else:
				print("Transition Scene hasn't been found. Check your launching method.")
		else:
			from.visible = false
			var new_scene = MAIN.get_node(to)
			new_scene.visible = true
			new_scene.call_deferred(to)
	else:
		print("MAIN Scene hasn't been found. Check your launching method.")
