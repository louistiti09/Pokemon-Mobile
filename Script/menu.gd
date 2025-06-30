extends Node2D

@onready var UI = {
	"Version" : $BG/Version,
	"Partenaire" : $BG/Center/Partenaire,
	"Avatar" : $BG/Center/Avatar,
	"LvPartenaire" : $BG/Center/LvPartenaire/Label,
	"LvDresseur" : $BG/Center/LvDresseur/Label,
	"Team" : $BG/Center/Team,
	"TeamName" : $BG/SelectedTeam/Panel/Label,
}
@onready var Audios = {
	"Button" : $Audios/Button,
	"SFX" : $Audios/SFX,
	"BGM" : $Audios/BGM
}

func _ready(): if get_parent().get_class() == "Window": menu()
func menu():
	Audios.BGM.playing = true
	var data = SaveManager.load_data()
	
	var partenaire = data.Partenaire
	var p_name = partenaire.Name
	var pokedex = Stats.POKEMONS.keys().find(p_name)+1
	UI.Partenaire.texture = load("res://Textures/Pokemons/Front/%s/%s.png" % [partenaire.Shiny,pokedex])
	UI.LvPartenaire.text = "Lv. %s" % partenaire.LvL
	Audios.SFX.stream = load("res://Sounds/SFX/Pokemon/%s.ogg" % p_name)
	if partenaire.Nickname != null: p_name = partenaire.Nickname
	
	selected_team = data.ActiveTeam
	UI.Team.text = "%s & %s" % [p_name,data.Pseudo]
	UI.TeamName.text = data.Teams[selected_team].Name
	
	UI.Avatar.frame = data.Avatar
	UI.LvDresseur.text = "Lv. %s" % data.PlayerLvL
	
	UI.Version.text = "v%s" % SceneManager.version
	if SceneManager.version < 1: UI.Version.text += " (Beta)"

func _on_partenaire_pressed():
	if !Audios.SFX.playing:
		$AnimationPlayer.play("roar")

var selected_team = 0
func _on_selected_team_pressed():
	Audios.Button.playing = true
	SceneManager.change_scene(self,"team_builder",true,[selected_team])

func _on_pokedex_pressed():
	Audios.Button.playing = true
	SceneManager.change_scene(self,"pokedex",true)
