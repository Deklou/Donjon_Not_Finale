extends Node

#Script contenant toutes les datas du jeu


#variables de base du joueur

var player_MAX_HP : int = 22 #Limite haute des points de vie
var player_HP : int = 22 #valeur qui peut varier entre 0 et les points de vie maximals
var player_STR : int = 6 #Nombre de points de vie qu'on retire à la cible
var player_DEX : float = 5 #Valeur qui conditionne les dégâts critiques et aux dégâts/activation de certaines techniques
var player_DEF : int = 5 #Valeur qui sera soustraite aux dégâts reçus

#variables relatives au niveau du joueur

var player_LVL : int = 1 #Niveau
var player_XP : int = 0 #expérience
var player_CP : int = 0 #point de compétence

#variables calculées du joueur

var player_MT : int = player_STR #dégâts totaux
var player_CRT : int = 0 #% de coup critique
var player_base_CRT : int = 0 #sert de valeur étalon pour la comparaison avec le crit

#variables tampons

var player_LVL_buffer : int = player_LVL
var player_XP_buffer : int = player_XP
var player_MAX_HP_buffer : int = player_MAX_HP
var player_HP_buffer : int = player_HP
var player_CP_buffer : int = player_CP #nécéssaire car on doit comparer la valeur de base et la valeur gagnée
var player_MT_buffer : int = player_MT #nécéssaire car la stat évolue selon l'équipement
var player_CRT_buffer : int = player_CRT #nécéssaire car la stat évolue selon la dextérité et l'équipement
var player_STR_buffer : int = player_STR #nécéssaire car le joueur peut augmenter et baisser cette stat
var player_DEX_buffer : float = player_DEX #nécéssaire car le joueur peut augmenter et baisser cette stat
var player_DEF_buffer : int = player_DEF #nécéssaire car le joueur peut augmenter et baisser cette stat

#variables relatives au tour du joueur

var player_MAX_movement_point: int = 2 #points max de mouvement possibles
var player_MAX_action_point: int = 2 #points max d'actions possibles
var player_current_movement_point: int = 2 #points de mouvements actuels du joueur
var player_current_action_point: int = 2 #points d'actions actuels du joueur

############################################################################################

#Stats de base des ennemis

var enemy_stats = {} #Dictionnaire qui contiendra des sous dictionnaires contenant les stats de chaque ennemi
var enemy_inventory = {} #Dictionnaire qui contiendra les inventaires des ennemis

var enemy_MAX_HP : int = 22 #Limite haute des points de vie
var enemy_HP : int = 22 #valeur qui peut varier entre 0 et les points de vie maximals
var enemy_STR : int = 6 #Nombre de points de vie qu'on retire à la cible
var enemy_DEX : float = 5 #Valeur qui conditionne les dégâts critiques et aux dégâts/activation de certaines techniques
var enemy_DEF : int = 5 #Valeur qui sera soustraite aux dégâts reçus

#stats relatives au niveau de l'ennemi

var enemy_LVL : int = 1 #Niveau
var enemy_XP : int = 10 #expérience reçu si l'ennemi est vaincu

#valeurs calculées de l'ennemi

var enemy_MT : int = enemy_STR #dégâts totaux
var enemy_CRT : int = 0 #% de coup critique

#valeur tampons

var enemy_MAX_HP_buffer : int = enemy_MAX_HP #Limite haute des points de vie
var enemy_HP_buffer : int = enemy_HP #valeur qui peut varier entre 0 et les points de vie maximals
var enemy_MT_buffer : int = enemy_MT #dégâts totaux
var enemy_CRT_buffer : int = enemy_CRT #% de coup critique
var enemy_STR_buffer : int = enemy_STR #Nombre de points de vie qu'on retire à la cible
var enemy_DEX_buffer : float = enemy_DEX #Valeur qui conditionne les dégâts critiques et aux dégâts/activation de certaines techniques
var enemy_DEF_buffer : int = enemy_DEF #Valeur qui sera soustraite aux dégâts reçus

#variables relatives au tour du joueur

var enemy_MAX_movement_point: int = 1 #points max de mouvement possibles
var enemy_MAX_action_point: int = 1 #points max d'actions possibles
var enemy_current_movement_point: int = 1 #points de mouvements actuels de l'ennemi
var enemy_current_action_point: int = 1 #points d'actions actuels de l'ennemu

############################################################################################

var turn_number : int = 1 #Nombre de tour
var legendary_weapon_acquired : int #Compte le nombre d'armes légendaires obtenues
var enemy_defeated : int #Compte le nombre d'ennemi vaincu
var timer : float = 0 #temps de jeu
var all_objective_completed : bool = false #si tous les objectifs de la données ont été complétés
var secret_triggered : bool = false 

func _process(delta):
	timer = timer + delta

#Objets

var Item = { #Item est un dictoonnaire, lui même composé de dictionnaire qui représentent chacun un objet
	
	################## Objets de Soins ##################
	
	"Pain":{ #On peut accéder aux différentes informations de l'objet grâce à Item[item_name].nom_de_l_information
	"Type" : "Item",
	"Sous_Type":"Soin" ,
	"Name" : "Pain",
	"Description" : "Du pain. Rend 15 PV",
	"Icon": preload("res://Sprites/Items/bread.png"),
	"Value":15,
	"Cost": 0
	}
	,"Pain rassis":{
	"Type" : "Item",
	"Sous_Type":"Soin" ,
	"Name" : "Pain rassis",
	"Description" : "Pain rassis. il est dans un\nétat lamentable.\nRend 5 PV",
	"Icon": preload("res://Sprites/Items/stale_bread.png"),
	"Value":5,
	"Cost": 0
	}
	
	################## Objets de Buff ##################
	
	,"buff_attaque":{
	"Type" : "Item",
	"Sous_Type":"Buff" ,
	"Name" : "",
	"Description" : "STR +2 jsuqu'à la fin du combat",
	"Icon": "",
	"Value": [2,0,0], #STR, DEX et DEF
	"Cost": 0
	}
	,"buff_defense":{
	"Type" : "Item",
	"Sous_Type":"Buff" ,
	"Name" : "",
	"Description" : "DEF +2 jsuqu'à la fin du combat",
	"Icon": "",
	"Value": [0,0,2], #STR, DEX et DEF
	"Cost": 0
	}
	
	################## Armes ##################
	
	,"Epée courte":{
	"Type" : "Weapon",
	"Name" : "Epée courte",
	"Description" : "Epée standard\ncomposée d'un métal\nsimple.",
	"Icon": preload("res://Sprites/Weapon/IronSword.png"),
	"Value": [3,0,2], #puissance, critique, poids
	"Cost": 0,
	"Equiped": false
	}
	
	,"Libération":{
	"Type" : "Weapon",
	"Name" : "Libération",
	"Description" : "Epée personnelle du\ndragon divin.",
	"Icon": preload("res://Sprites/Weapon/Liberation.png"),
	"Value": [6,0,4], #puissance, critique, poids
	"Cost": 0,
	"Equiped": false
	}
	
	,"Miséricorde":{
	"Type" : "Weapon",
	"Name" : "Miséricorde",
	"Description" : "Dague légendaire\nacérée.\n",
	"Icon": preload("res://Sprites/Weapon/Misericorde.png"),
	"Value": [2,20,2], #puissance, critique, poids
	"Cost": 0,
	"Equiped": false
	}
	
	,"Représailles":{
	"Type" : "Weapon",
	"Name" : "Représailles",
	"Description" : "Lance légendaire\nvenue d'un monde\nlointain.",
	"Icon": preload("res://Sprites/Weapon/Trahison.png"),
	"Value": [9,0,9], #puissance, critique, poids
	"Cost": 0,
	"Equiped": false
	}
}
