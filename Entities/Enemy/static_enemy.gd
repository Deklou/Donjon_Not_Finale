extends CharacterBody2D

@export var dummy_id : String = "" #Identifiant unique pour chaque ennemi
@export var dummy_name : String = "" #Identifiant unique pour chaque ennemi
@export var dummy_LVL_offset : int 
@export var dummy_MAX_HP_offset : int
@export var dummy_STR_offset : int
@export var dummy_DEX_offset : int
@export var dummy_DEF_offset : int

@export var enemy_item_1 : String  # Nom de l'objet 1 dans l'inventaire de l'ennemi
@export var enemy_item_2 : String  # Nom de l'objet 2 dans l'inventaire de l'ennemi
@export var enemy_item_3 : String  # Nom de l'objet 3 dans l'inventaire de l'ennemi

var dummy_stats = {"Name": "",
"LVL" : GameData.enemy_LVL,
"XP" : GameData.enemy_XP,
"MAX_HP" : GameData.enemy_MAX_HP,
"HP" : GameData.enemy_HP,
"MT" : GameData.enemy_MT,
"CRT" : GameData.enemy_CRT,
"STR" : GameData.enemy_STR,
"DEX" : GameData.enemy_DEX,
"DEF" : GameData.enemy_DEF
}

var dummy_inventory = []
var mouse_click_count : int = 0

func _ready(): #check l'état de l'ennemi à chaque fois que l'objet est instancié
	
	dummy_inventory = [enemy_item_1, enemy_item_2, enemy_item_3]
	GameData.enemy_inventory[dummy_id] = dummy_inventory #Dès qu'on instancie un ennemi, on envoie son inventaire dans GameData
	
	dummy_stats.LVL += dummy_LVL_offset
	dummy_stats.MAX_HP += dummy_MAX_HP_offset
	dummy_stats.HP += dummy_MAX_HP_offset
	dummy_stats.MT += dummy_STR_offset
	dummy_stats.CRT += dummy_DEX_offset/4
	dummy_stats.STR += dummy_STR_offset
	dummy_stats.DEX += dummy_DEX_offset
	dummy_stats.DEF += dummy_DEF_offset
	
	#On check l'inventaire

	if not dummy_inventory.is_empty(): #A chaque fois qu'on instancie un ennemi, la première chose qu'on fait est de lui équipper son arme
		for item_name in dummy_inventory:
			if item_name != "":
				if GameData.Item[item_name].Type == "Weapon":
					dummy_stats.MT = dummy_stats.STR + GameData.Item[item_name].Value[0]
					dummy_stats.CRT = dummy_stats.CRT + GameData.Item[item_name].Value[1]

	dummy_stats.Name = dummy_name #On assigne le nom de l'ennemi maintenant sinon l'export de la variable n'est pas instancié
	GameData.enemy_stats[dummy_id] = dummy_stats #Dès qu'on instancie un ennemi, on envoie les stats dans GameData

func _on_area_2d_mouse_entered():
	EntitiesState.selected_id = dummy_id

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true:
		EntitiesState.enemy_selected(get_position()) #on aeppelle la fonction pour rendre visible l'interface ennemi #on remet l'état à faux pour qu'il ne soit appelé qu'une fois
		mouse_click_count +=1
		if EntitiesState.selected_id != EntitiesState.enemy_id:
			mouse_click_count = 1
		if mouse_click_count == 2:
			EntitiesState.enemy_is_deselected()
			mouse_click_count = 0
		EntitiesState.enemy_id = dummy_id
