extends Node2D

@onready var sample_hbox = $Sample
@onready var sample_pkm = $Pkm
@onready var pkm_name = $PkmName
@onready var vbox = $BG/Scroll/VBox
@onready var Audios = {
	"Button" : $Audios/Button,
	"SFX" : $Audios/SFX,
	"BGM" : $Audios/BGM
}

func _ready(): if get_parent().get_class() == "Window": pokedex()
func pokedex():
	Audios.BGM.playing = true
	var data = SaveManager.load_data()
	var Pokedex = []
	for pkm in data.Pokemons: Pokedex.append(pkm.Name)
	for team in data.Teams: for pkm in team.Team: Pokedex.append(pkm.Name)
	for i in range(3):
		for p_name in Stats.POKEMONS:
			var p = Stats.POKEMONS[p_name]
			if p.Evolution == null: continue
			var add_base = false
			if typeof(p.Evolution) == TYPE_ARRAY: for evo in p.Evolution: add_base = Pokedex.has(evo.Name) && !Pokedex.has(p_name) && add_base == false
			else: add_base = Pokedex.has(p.Evolution.Name) && !Pokedex.has(p_name)
			if add_base: Pokedex.append(p_name)
	
	for child in vbox.get_children(): vbox.remove_child(child)
	
	var i = 0
	var hbox
	for pkm in Stats.POKEMONS:
		i+=1
		if i%5 == 1:
			hbox = sample_hbox.duplicate()
			hbox.name = str(ceil(i/5.0)+1)
			vbox.add_child(hbox)
			hbox.visible = true
		var pkm_panel = sample_pkm.duplicate()
		if (Pokedex.has(pkm) || i<=151) :
			if Pokedex.has(pkm):
				pkm_panel.get_node("TextureRect").texture = load("res://Textures/Pokemons/Front/n/%s.png" % i)
				pkm_panel.get_node("Label").visible = false
				pkm_panel.connect("mouse_entered",func():show_pkm_name(pkm))
				pkm_panel.connect("pressed",func():pkm_click("res://Sounds/SFX/Pokemon/%s.ogg" % pkm))
			else:
				pkm_panel.get_node("Label").text = str(i)
				pkm_panel.get_node("TextureRect").visible = false
				pkm_panel.connect("mouse_entered",func():show_pkm_name("?"))
				pkm_panel.connect("pressed",func():pkm_click("res://Sounds/SFX/Other/Wrong.mp3"))
			hbox.add_child(pkm_panel)
			pkm_panel.visible = true
			pkm_panel.connect("mouse_exited",func():hide_pkm_name())
	for _i in range(5-hbox.get_child_count()):
		var pkm_panel = sample_pkm.duplicate()
		pkm_panel.get_node("Label").visible = false
		pkm_panel.get_node("TextureRect").visible = false
		pkm_panel.disabled = true
		pkm_panel.visible = true
		hbox.add_child(pkm_panel)
	vbox.add_child(ColorRect.new())

func show_pkm_name(pname : String):
	pkm_name.get_node("Label").text = pname
	pkm_name.visible = true

func hide_pkm_name():
	pkm_name.visible = false

func pkm_click(sound_path : String):
	Audios.SFX.stream = load(sound_path)
	Audios.SFX.playing = true

func _on_quitter_pressed():
	Audios.Button.playing = true
	get_tree().quit()#babye

func _process(_delta):
	pkm_name.global_position = get_global_mouse_position()+Vector2(-25,-50)
	if pkm_name.global_position.x > 544-pkm_name.size.x:
		pkm_name.global_position = get_global_mouse_position()+Vector2(-125,-50)
