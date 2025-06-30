extends Node

@onready var MAIN = get_node_or_null("/root/MAIN")

const version = 0.1

func _ready():
	if MAIN != null:
		hide_all_scenes()
		var t = MAIN.get_node_or_null("transition")
		if t != null: t.visible = true
		print("Game Ready")
		execute_scene("title_scene")

func change_scene(from : Node2D, to : String, animation : bool = true, args : Array = []):
	if MAIN != null:
		cut_bgm(from,animation)
		if animation:
			var Transition = MAIN.get_node_or_null("transition")
			if Transition != null:
				Transition.transition_in()
				await get_tree().create_timer(1.5).timeout
				from.visible = false
				execute_scene(to,args)
				Transition.transition_out()
			else:
				print("Transition Scene was not been found. Check your launching method.")
		else:
			from.visible = false
			execute_scene(to,args)
	else:
		print("MAIN Scene was not been found. Check your launching method.")

func execute_scene(scene_name : String, args : Array = []):
	var new_scene = MAIN.get_node_or_null(scene_name)
	if new_scene != null:
		new_scene.visible = true
		new_scene.callv(scene_name,args)
		print("\n -> Launching %s" % scene_name)
	elif scene_name != "title_scene":
		print("%s Scene was not been found. Check your launching method." % scene_name)
		print(" -> Redirecting to title_scene !")
		execute_scene("title_scene")
	else :
		print("-------------------------------------\n")
		print("CRASH : title_scene was not been found\n")
		print("-------------------------------------")

func cut_bgm(scene : Node2D, smooth : bool = false):
	var audios = scene.get_node_or_null("Audios")
	if audios != null:
		var bgm : AudioStreamPlayer = audios.get_node_or_null("BGM")
		if bgm != null:
			if smooth:
				var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
				tween.tween_property(bgm,"volume_db",-80,2)
				await tween.finished
				tween.kill()
				bgm.playing = false
				bgm.volume_db = 0
			else:
				bgm.playing = false
		else:
			print("BGM was not found in %s Scene/Audios : Passing" % scene.name)
	else:
		print("Audios was not found in %s Scene : Passing" % scene.name)

func hide_all_scenes():
	if MAIN != null:
		for child in MAIN.get_children():
			child.visible = false
