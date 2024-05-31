extends Node

##################### VARIABLE PAR DEFAUT #####################
var default_player_MAX_HP : int = 30
var default_player_HP : int = 30
var default_player_STR : int = 6
var default_player_DEX : float = 5 
var default_player_DEF : int = 0
var default_player_LVL : int = 1
var default_player_XP : int = 0
var default_player_CP : int = 0 
var default_player_MT : int = default_player_STR
var default_player_CRT : int = 0
var default_player_base_CRT : int = 0
var default_player_LVL_buffer : int = default_player_LVL
var default_player_XP_buffer : int = default_player_XP
var default_player_XP_over_level : int = 0
var default_player_MAX_HP_buffer : int = default_player_MAX_HP
var default_player_HP_buffer : int = default_player_HP
var default_player_CP_buffer : int = default_player_CP 
var default_player_MT_buffer : int = default_player_MT
var default_player_CRT_buffer : int = default_player_CRT
var default_player_STR_buffer : int = default_player_STR 
var default_player_DEX_buffer : float = default_player_DEX 
var default_player_DEF_buffer : int = default_player_DEF 
var default_player_MAX_movement_point: int = 1
var default_player_MAX_action_point: int = 22
var default_player_current_movement_point: int = 1
var default_player_current_action_point: int = 22
var default_enemy_MAX_HP : int = 22 
var default_enemy_HP : int = 22 
var default_enemy_STR : int = 6 
var default_enemy_DEX : float = 5 
var default_enemy_DEF : int = 4 
var default_enemy_LVL : int = 1 
var default_enemy_XP : int = 20 
var default_enemy_MT : int = default_enemy_STR 
var default_enemy_CRT : int = 0 
var default_enemy_base_CRT : int = 0 
var default_enemy_MAX_HP_buffer : int = default_enemy_MAX_HP 
var default_enemy_HP_buffer : int = default_enemy_HP 
var default_enemy_MT_buffer : int = default_enemy_MT 
var default_enemy_CRT_buffer : int = default_enemy_CRT 
var default_enemy_STR_buffer : int = default_enemy_STR 
var default_enemy_DEX_buffer : float = default_enemy_DEX 
var default_enemy_DEF_buffer : int = default_enemy_DEF 
var default_enemy_MAX_movement_point: int = 1 
var default_enemy_MAX_action_point: int = 1 
var default_enemy_current_movement_point: int = 1 
var default_enemy_current_action_point: int = 1 
var default_enemy_range_state : bool = false
var default_turn_number : int = 1 
var default_legendary_weapon_acquired : int 
var default_enemy_defeated : int 
var default_timer : float = 0 
var default_all_objective_completed : bool = false 
var default_secret_triggered : bool = false
##################### VARIABLES #####################
#variables de base du joueur
var player_MAX_HP : int #Limite haute des points de vie
var player_HP : int #valeur qui peut varier entre 0 et les points de vie maximals
var player_STR : int #Nombre de points de vie qu'on retire à la cible
var player_DEX : float #Valeur qui conditionne les dégâts critiques et aux dégâts/activation de certaines techniques
var player_DEF : int #Valeur qui sera soustraite aux dégâts reçus
#variables relatives au niveau du joueur
var player_LVL : int #Niveau
var player_XP : int #expérience
var player_CP : int #point de compétence
#variables calculées du joueur
var player_MT : int #dégâts totaux
var player_CRT : int #% de coup critique
var player_base_CRT : int #sert de valeur étalon pour la comparaison avec le crit
#variables tampons
var player_LVL_buffer : int
var player_XP_buffer : int
var player_XP_over_level : int #au cas où on passe plusieurs niveaux d'un coup
var player_MAX_HP_buffer : int
var player_HP_buffer : int
var player_CP_buffer : int #nécéssaire car on doit comparer la valeur de base et la valeur gagnée
var player_MT_buffer : int #nécéssaire car la stat évolue selon l'équipement
var player_CRT_buffer : int #nécéssaire car la stat évolue selon la dextérité et l'équipement
var player_STR_buffer : int #nécéssaire car le joueur peut augmenter et baisser cette stat
var player_DEX_buffer : float #nécéssaire car le joueur peut augmenter et baisser cette stat
var player_DEF_buffer : int #nécéssaire car le joueur peut augmenter et baisser cette stat
#variables relatives au tour du joueur
var player_MAX_movement_point: int #points max de mouvement possibles
var player_MAX_action_point: int #points max d'actions possibles
var player_current_movement_point: int #points de mouvements actuels du joueur
var player_current_action_point: int #points d'actions actuels du joueur
############################################################################################
#Stats de base des ennemis
var enemy_stats = {} #Dictionnaire qui contiendra des sous dictionnaires contenant les stats de chaque ennemi
var enemy_inventory = {} #Dictionnaire qui contiendra les inventaires des ennemis
var enemy_MAX_HP : int #Limite haute des points de vie
var enemy_HP : int #valeur qui peut varier entre 0 et les points de vie maximals
var enemy_STR : int #Nombre de points de vie qu'on retire à la cible
var enemy_DEX : float #Valeur qui conditionne les dégâts critiques et aux dégâts/activation de certaines techniques
var enemy_DEF : int #Valeur qui sera soustraite aux dégâts reçus
#stats relatives au niveau de l'ennemi
var enemy_LVL : int #Niveau
var enemy_XP : int #expérience reçu si l'ennemi est vaincu
#valeurs calculées de l'ennemi
var enemy_MT : int #dégâts totaux
var enemy_CRT : int #% de coup critique
var enemy_base_CRT : int #sert de valeur étalon pour la comparaison avec le crit
#valeur tampons
var enemy_MAX_HP_buffer : int #Limite haute des points de vie
var enemy_HP_buffer : int #valeur qui peut varier entre 0 et les points de vie maximals
var enemy_MT_buffer : int #dégâts totaux
var enemy_CRT_buffer : int #% de coup critique
var enemy_STR_buffer : int #Nombre de points de vie qu'on retire à la cible
var enemy_DEX_buffer : float #Valeur qui conditionne les dégâts critiques et aux dégâts/activation de certaines techniques
var enemy_DEF_buffer : int #Valeur qui sera soustraite aux dégâts reçus
var enemy_MAX_movement_point: int #points max de mouvement possibles
var enemy_MAX_action_point: int #points max d'actions possibles
var enemy_current_movement_point: int #points de mouvements actuels de l'ennemi
var enemy_current_action_point: int #points d'actions actuels de l'ennemu
var enemy_range_state : bool #vérifie si l'ennemi peut être attaqué au corps à corps
############################################################################################
var turn_number : int #Nombre de tour
var player_death_count : int = 0 #Nombre de morts du joueur
var legendary_weapon_acquired : int #Compte le nombre d'armes légendaires obtenues
var enemy_defeated : int #Compte le nombre d'ennemi vaincu
var timer : float #temps de jeu
var all_objective_completed : bool #si tous les objectifs de la données ont été complétés
var secret_triggered : bool #indique si un événement secret a été déclenché
##################### OBJETS #####################

var Item = { #Item est un dictoonnaire, lui même composé de dictionnaire qui représentent chacun un objet
	
	################## Objets de Soins ##################
	"Pain":{ #On peut accéder aux différentes informations de l'objet grâce à Item[item_name].nom_de_l_information
	"Type" : "Consumable",
	"Sous_Type":"Soin" ,
	"Name" : "Pain",
	"Description" : "Du pain. Soigne 10 PV.",
	"Icon": preload("res://Sprites/Items/bread.png"),
	"Value":10,
	"Cost": 0,
	"Article" : "du"
	}
	,"Pain rassis":{
	"Type" : "Consumable",
	"Sous_Type":"Soin" ,
	"Name" : "Pain rassis",
	"Description" : "Pain rassis. Il est dans un\nétat lamentable.\nSoigne 5 PV.",
	"Icon": preload("res://Sprites/Items/stale_bread.png"),
	"Value":5,
	"Cost": 0,
	"Article" : "du"
	}
	,"Sandwich classique":{
	"Type" : "Consumable",
	"Sous_Type":"Soin" ,
	"Name" : "Sandwich classique",
	"Description" : "Sandwich. Certainement\npas la meilleure recette\nqui existe. Soigne 15 PV.",
	"Icon": preload("res://Sprites/Items/stale_bread.png"),
	"Value":15,
	"Cost": 0,
	"Article" : "un"
	}
	,"Concoction":{
	"Type" : "Consumable",
	"Sous_Type":"Soin" ,
	"Name" : "Concoction",
	"Description" : "Mixture étrange qui\nvous remet sur pied en un\nclin d'oeil.",
	"Icon": preload("res://Sprites/Items/stale_bread.png"),
	"Value":100,
	"Cost": 0,
	"Article" : "une"
	}
	################## Armes ##################
	,"Bâton":{
	"Type" : "Weapon",
	"Name" : "Bâton",
	"Description" : "Taillé à partir d'un\nbois solide, mais usé par\nle passage du temps.",
	"Icon": preload("res://Sprites/Weapon/IronSword.png"),
	"Value": [1,0,2], #puissance, critique, poids
	"Cost": 0,
	"Article" : "un",
	"Equiped": false
	}
	,"Epée courte":{
	"Type" : "Weapon",
	"Name" : "Epée courte",
	"Description" : "Epée standard\ncomposée d'un métal\nsimple.",
	"Icon": preload("res://Sprites/Weapon/IronSword.png"),
	"Value": [3,0,2], #puissance, critique, poids
	"Cost": 0,
	"Article" : "une",
	"Equiped": false
	}
	,"Libération":{
	"Type" : "Weapon",
	"Name" : "Libération",
	"Description" : "Epée personnelle du\ndragon divin.",
	"Icon": preload("res://Sprites/Weapon/Liberation.png"),
	"Value": [5,0,4], #puissance, critique, poids
	"Cost": 0,
	"Article" : "",
	"Equiped": false
	}
	,"Miséricorde":{
	"Type" : "Weapon",
	"Name" : "Miséricorde",
	"Description" : "Dague légendaire\nacérée.\n",
	"Icon": preload("res://Sprites/Weapon/Misericorde.png"),
	"Value": [3,25,2], #puissance, critique, poids
	"Cost": 0,
	"Article" : "",
	"Equiped": false
	}
	,"Représailles":{
	"Type" : "Weapon",
	"Name" : "Représailles",
	"Description" : "Lance légendaire\nvenue d'un monde\nlointain.",
	"Icon": preload("res://Sprites/Weapon/Trahison.png"),
	"Value": [7,0,9], #puissance, critique, poids
	"Cost": 0,
	"Article" : "",
	"Equiped": false
	}
	################## Objets Spéciaux ##################
	,"Kojirō":{
	"Type" : "Special",
	"Name" : "Kojirō",
	"Description" : "C'est Kojirō !!\nSes plumes bleues\nsont tout à fait charmantes.",
	"Icon": preload("res://Sprites/Items/kojiro.png"),
	"Value": [0,0,0], #puissance, critique, poids
	"Cost": 0,
	"Article" : "",
	}
}

##################### RESET VALUE #####################
func _reset_gamedata_value():
	player_MAX_HP = default_player_MAX_HP
	player_HP = default_player_HP
	player_STR = default_player_STR
	player_DEX = default_player_DEX
	player_DEF = default_player_DEF
	player_LVL = default_player_LVL
	player_XP = default_player_XP
	player_CP = default_player_CP
	player_MT = default_player_MT
	player_CRT = default_player_CRT
	player_base_CRT = default_player_base_CRT
	player_LVL_buffer = default_player_LVL_buffer
	player_XP_buffer = default_player_XP_buffer
	player_XP_over_level = default_player_XP_over_level
	player_MAX_HP_buffer = default_player_MAX_HP_buffer
	player_HP_buffer = default_player_HP_buffer
	player_CP_buffer = default_player_CP_buffer
	player_MT_buffer = default_player_MT_buffer
	player_CRT_buffer = default_player_CRT_buffer
	player_STR_buffer = default_player_STR_buffer
	player_DEX_buffer = default_player_DEX_buffer
	player_DEF_buffer = default_player_DEF_buffer
	player_MAX_movement_point = default_player_MAX_movement_point
	player_MAX_action_point = default_player_MAX_action_point
	player_current_movement_point = default_player_current_movement_point
	player_current_action_point = default_player_current_action_point
	enemy_stats.clear()
	enemy_inventory.clear()
	enemy_MAX_HP = default_enemy_MAX_HP
	enemy_HP = default_enemy_HP
	enemy_STR = default_enemy_STR
	enemy_DEX = default_enemy_DEX
	enemy_DEF = default_enemy_DEF
	enemy_LVL = default_enemy_LVL
	enemy_XP = default_enemy_XP
	enemy_MT = default_enemy_MT
	enemy_CRT = default_enemy_CRT
	enemy_base_CRT = default_enemy_base_CRT
	enemy_MAX_HP_buffer = default_enemy_MAX_HP_buffer
	enemy_HP_buffer = default_enemy_HP_buffer
	enemy_MT_buffer = default_enemy_MT_buffer
	enemy_CRT_buffer = default_enemy_CRT_buffer
	enemy_STR_buffer = default_enemy_STR_buffer
	enemy_DEX_buffer = default_enemy_DEX_buffer
	enemy_DEF_buffer = default_enemy_DEF_buffer
	enemy_MAX_movement_point = default_enemy_MAX_movement_point
	enemy_MAX_action_point = default_enemy_MAX_action_point
	enemy_current_movement_point = default_enemy_current_movement_point
	enemy_current_action_point = default_enemy_current_action_point
	enemy_range_state = default_enemy_range_state
	turn_number = default_turn_number
	legendary_weapon_acquired = default_legendary_weapon_acquired
	enemy_defeated = default_enemy_defeated
	timer = default_timer
	all_objective_completed = default_all_objective_completed
	secret_triggered = default_secret_triggered
	for item in Item:
		if GameData.Item[item].Type == "Weapon":
			GameData.Item[item].Equiped = false
##################### READY #####################
func _ready():
	_reset_gamedata_value()
##################### PROCESS #####################

func _process(delta):
	timer = timer + delta
