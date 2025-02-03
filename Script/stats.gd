extends Node

const POKEMONS = {
	"Bulbizarre": {
		"Pokedex":1,
		"PV":45,
		"Attaque":49,
		"Defense":49,
		"Vitesse":45,
		"AttaqueSpe":65,
		"DefenseSpe":65,
		"Type1":"Plante",
		"Type2":"Poison",
		"NativeAttacks":[
			{"Attack":"Charge","LvL":0},
			{"Attack":"Rugissement","LvL":0},
			{"Attack":"Vampigraine","LvL":7},
			{"Attack":"Fouet Lianes","LvL":13},
			{"Attack":"Poudre Toxik","LvL":20},
			{"Attack":"Tranch'Herbe","LvL":27},
			{"Attack":"Croissance","LvL":34},
			{"Attack":"Poudre Dodo","LvL":41},
			{"Attack":"Lance-Soleil","LvL":48},
		]
	}
}

const NATURE = {#[Boost,Malus]
	"Assuré":["Defense","Attaque"],
	"Bizarre":["",""],
	"Brave":["Attaque","Vitesse"],
	"Calme":["DefenseSpe","Attaque"],
	"Discret":["AttaqueSpe","Vitesse"],
	"Docile":["",""],
	"Doux":["AttaqueSpe","Defense"],
	"Foufou":["AttaqueSpe","DefenseSpe"],
	"Gentil":["DefenseSpe","Defense"],
	"Hardi":["",""],
	"Jovial":["Vitesse","AttaqueSpe"],
	"Lâche":["Defense","DefenseSpe"],
	"Malin":["Defense","AttaqueSpe"],
	"Malpoli":["DefenseSpe","Vitesse"],
	"Mauvais":["Attaque","DefenseSpe"],
	"Modeste":["AttaqueSpe","Attaque"],
	"Naïf":["Vitesse","DefenseSpe"],
	"Pressé":["Vitesse","Defense"],
	"Prudent":["DefenseSpe","AttaqueSpe"],
	"Pudique":["",""],
	"Relax":["Defense","Vitesse"],
	"Rigide":["Attaque","AttaqueSpe"],
	"Sérieux":["",""],
	"Solo":["Attaque","Defense"],
	"Timide":["Vitesse","Attaque"]
}

const ATTACKS = {
	"Lutte": {
		"PP":null,
		"Type":"Normal",
		"Puissance":50,
		"Precision":null,
		"Priorite":0,
		"Critique":1,
		"Categorie":"Physique"
	},
	"Charge": {
		"PP":35,
		"Type":"Normal",
		"Puissance":35,
		"Precision":95,
		"Priorite":0,
		"Critique":1,
		"Categorie":"Physique"
	},
	"Rugissement": {
		"PP":40,
		"Type":"Normal",
		"Puissance":0,
		"Precision":100,
		"Priorite":0,
		"Critique":1,
		"Categorie":"Statut"
	}
}

const TYPE_COLOR = {
	"Normal": Color8(162,162,162),
	"Feu": Color8(252,28,29),
	"Eau": Color8(20,132,255),
	"Plante": Color8(45,169,16),
	"Electrik": Color8(255,193,0),
	"Glace": Color8(26,224,253),
	"Combat": Color8(255,125,3),
	"Poison": Color8(158,58,236),
	"Sol": Color8(161,77,19),
	"Vol": Color8(117,185,255),
	"Psy": Color8(255,56,125),
	"Insecte": Color8(144,166,2),
	"Roche": Color8(178,169,118),
	"Spectre": Color8(121,61,122),
	"Dragon": Color8(75,97,255)
}

const MODIF_STAT = {
	6 : 4.0,
	5 : 7/2.0,
	4 : 3.0,
	3 : 5/2.0,
	2 : 2.0,
	1 : 3/2.0,
	0 : 1.0,
	-1 : 2/3.0,
	-2 : 1/2.0,
	-3 : 2/5.0,
	-4 : 1/3.0,
	-5 : 2/7.0,
	-6 : 1/4.0
}

const MODIF_PRE = {
	6 : 3.0,
	5 : 8/3.0,
	4 : 7/3.0,
	3 : 2.0,
	2 : 5/3.0,
	1 : 4/3.0,
	0 : 1.0,
	-1 : 3/4.0,
	-2 : 3/5.0,
	-3 : 1/2.0,
	-4 : 3/7.0,
	-5 : 3/8.0,
	-6 : 1/3.0
}

const TABLE_TYPE = {
	"Normal" : {
		"Roche" : 0.5,
		"Spectre" : 0
	},
	"Feu" : {
		"Feu" : 0.5,
		"Eau" : 0.5,
		"Plante" : 2,
		"Glace" : 2,
		"Insecte" : 2,
		"Roche" : 0.5,
		"Dragon" : 0.5
	},
	"Eau" : {
		"Feu" : 2,
		"Eau" : 0.5,
		"Plante" : 0.5,
		"Sol" : 2,
		"Roche" : 2,
		"Dragon" : 0.5
	},
	"Plante" : {
		"Feu" : 0.5,
		"Eau" : 2,
		"Plante" : 0.5,
		"Poison" : 0.5,
		"Sol" : 2,
		"Vol" : 0.5,
		"Insecte" : 0.5,
		"Roche" : 2,
		"Dragon" : 0.5
	},
	"Electrik" : {
		"Eau" : 2,
		"Plante" : 0.5,
		"Electrik" : 0.5,
		"Sol" : 0,
		"Vol" : 2,
		"Dragon" : 0.5
	},
	"Glace" : {
		"Eau" : 0.5,
		"Plante" : 2,
		"Glace" : 0.5,
		"Sol" : 2,
		"Vol" : 2,
		"Dragon" : 2
	},
	"Combat" : {
		"Normal" : 2,
		"Glace" : 2,
		"Poison" : 0.5,
		"Vol" : 0.5,
		"Psy" : 0.5,
		"Insecte" : 0.5,
		"Roche" : 2,
		"Spectre" : 0
	},
	"Poison" : {
		"Plante" : 2,
		"Poison" : 0.5,
		"Sol" : 0.5,
		"Insecte" : 2,
		"Roche" : 0.5,
		"Spectre" : 0.5
	},
	"Sol" : {
		"Feu" : 2,
		"Plante" : 0.5,
		"Electrik" : 2,
		"Poison" : 2,
		"Vol" : 0,
		"Insecte" : 0.5,
		"Roche" : 2
	},
	"Vol" : {
		"Plante" : 2,
		"Electrik" : 0.5,
		"Combat" : 2,
		"Insecte" : 2,
		"Roche" : 0.5
	},
	"Psy" : {
		"Combat" : 2,
		"Poison" : 2,
		"Psy" : 0.5
	},
	"Insecte" : {
		"Feu" : 0.5,
		"Plante" : 2,
		"Combat" : 0.5,
		"Poison" : 2,
		"Vol" : 0.5,
		"Psy" : 2,
		"Spectre" : 0.5
	},
	"Roche" : {
		"Feu" : 2,
		"Glace" : 2,
		"Combat" : 0.5,
		"Sol" : 0.5,
		"Vol" : 2,
		"Insecte" : 2
	},
	"Spectre" : {
		"Normal" : 0,
		"Psy" : 0,
		"Spectre" : 2
	},
	"Dragon" : {
		"Dragon" : 2
	}
}
