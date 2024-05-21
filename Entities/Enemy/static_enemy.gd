extends CharacterBody2D

@export var dummy_id : String = "" #Identifiant unique pour chaque ennemi
@export var dummy_name : String = "" #Identifiant unique pour chaque ennemi
@export var dummy_LVL_offset : int #Pour modifier le niveau de base via l'interface
@export var dummy_XP_offset : int #Pour modifier l'expérience reçu via l'interface
@export var dummy_MAX_HP_offset : int #Pour modifier les HP Max de base via l'interface
@export var dummy_STR_offset : int #Pour modifier la STR de base via l'interface
@export var dummy_DEX_offset : int #Pour modifier la DEX de base via l'interface
@export var dummy_DEF_offset : int #Pour modifier la DEF de base via l'interface
@export var dummy_MVT_offset : int #Pour modifier le mouvement de base via l'interface
@export var dummy_ACT_offset : int #Pour modifier le nombre d'actions de base via l'interface
@export var enemy_item_1 : String  # Nom de l'objet 1 dans l'inventaire de l'ennemi
@export var enemy_item_2 : String  # Nom de l'objet 2 dans l'inventaire de l'ennemi
@export var enemy_item_3 : String  # Nom de l'objet 3 dans l'inventaire de l'ennemi
@onready var damage_sprite_1 : Sprite2D = $damage_sprite_1 #Sprite temporaire de dégâts
@onready var damage_sprite_2 : Sprite2D = $damage_sprite_2 #Sprite temporaire de dégâts
@export var distance = 64 #taille d'une case
var currPos

var dummy_stats = {"Name": "",
"LVL" : GameData.enemy_LVL,
"XP" : GameData.enemy_XP,
"MAX_HP" : GameData.enemy_MAX_HP,
"HP" : GameData.enemy_HP,
"MT" : GameData.enemy_MT,
"CRT" : GameData.enemy_CRT,
"BASE_CRT" : GameData.enemy_base_CRT,
"STR" : GameData.enemy_STR,
"DEX" : GameData.enemy_DEX,
"DEF" : GameData.enemy_DEF,
"MVT" : GameData.enemy_current_movement_point,
"ACT" : GameData.enemy_current_action_point,
"MAX_MVT" : GameData.enemy_MAX_movement_point,
"MAX_ACT" : GameData.enemy_MAX_action_point
}

var dummy_inventory = [] #Inventaire de l'ennemi
var mouse_click_count : int = 0 #Nombre de clics souris pour l'affichage du selecteur
var dummy_range_entered : bool = false #Pour détecter si le joueur peut être attaqué

func _ready(): 
##################### STATS #####################
	dummy_inventory = [enemy_item_1, enemy_item_2, enemy_item_3]
	GameData.enemy_inventory[dummy_id] = dummy_inventory #Dès qu'on instancie un ennemi, on envoie son inventaire dans GameData
	dummy_stats.LVL += dummy_LVL_offset
	dummy_stats.XP += dummy_XP_offset
	dummy_stats.MAX_HP += dummy_MAX_HP_offset
	dummy_stats.HP += dummy_MAX_HP_offset
	dummy_stats.MT += dummy_STR_offset
	dummy_stats.STR += dummy_STR_offset
	dummy_stats.DEX += dummy_DEX_offset
	dummy_stats.DEF += dummy_DEF_offset
	dummy_stats.CRT = int(round(dummy_stats.DEX / 4.0))
	dummy_stats.BASE_CRT = dummy_stats.CRT
	dummy_stats.MAX_MVT += dummy_MVT_offset
	dummy_stats.MAX_ACT += dummy_ACT_offset
	dummy_stats.MVT = dummy_stats.MAX_MVT
	dummy_stats.ACT = dummy_stats.MAX_ACT
##################### INVENTAIRE #####################
	if not dummy_inventory.is_empty(): #A chaque fois qu'on instancie un ennemi, la première chose qu'on fait est de lui équipper son arme
		for item_name in dummy_inventory:
			if item_name != "":
				if GameData.Item[item_name].Type == "Weapon":
					dummy_stats.MT = dummy_stats.STR + GameData.Item[item_name].Value[0]
					dummy_stats.CRT = dummy_stats.CRT + GameData.Item[item_name].Value[1]
	dummy_stats.Name = dummy_name #On assigne le nom de l'ennemi maintenant sinon l'export de la variable n'est pas instancié
	GameData.enemy_stats[dummy_id] = dummy_stats #Dès qu'on instancie un ennemi, on envoie les stats dans GameData
##################### SIGNAL #####################
	EntitiesState.take_damage.connect(_entity_take_damage)
	GameState.enemy_can_act.connect(_enemy_ACT)
##################### POSITION #####################
	currPos = $".".position
	currPos.x = round(currPos.x / distance) * distance - 32
	currPos.y = round(currPos.y / distance) * distance - 32
	position = currPos
	
##################### INTERFACE ET SELECTEUR #####################

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
		EntitiesState.selected_id = dummy_id
		StatsSystem.update_stats()
		
##################### CONTACT JOUEUR #####################
		
func _on_area_2d_body_entered(body):
	if body is Node2D:
		dummy_range_entered = true
		GameState.enemy_range_entered = true
		EntitiesState.enemy_id = dummy_id
		EntitiesState.selected_id = dummy_id
		EntitiesState.enemy_can_be_attacked_id = dummy_id
		EntitiesState.enemy_can_be_attacked_position = get_position()
		EntitiesState.enemy_selected(get_position())		
		EntitiesState.enemy_triggered_list.append(dummy_id)
		
func _on_area_2d_body_exited(body):
	if body is Node2D and dummy_id not in EntitiesState.enemy_states:
		dummy_range_entered = false 
		GameState.enemy_range_entered = false
		EntitiesState.enemy_is_deselected()
		EntitiesState.enemy_triggered_list.remove_at(EntitiesState.enemy_triggered_list.find(dummy_id))
		
##################### DEGAT #####################

func _entity_take_damage(Entity_Name: String):
	if EntitiesState.enemy_id == dummy_id and Entity_Name == "Enemy":
		damage_sprite_1.visible = true
		await get_tree().create_timer(0.05).timeout
		damage_sprite_1.visible = false
		await get_tree().create_timer(0.05).timeout
		damage_sprite_2.visible = true
		await get_tree().create_timer(0.05).timeout
		damage_sprite_2.visible = false

##################### PROCESS #####################

func _process(_delta):
	if EntitiesState.enemy_is_dead(dummy_id): #Si l'ennemi est vaincu
		GameState.enemy_range_entered = false #Cas où joueur élimine ennemi mais le flag reste true
		$".".queue_free()
		
##################### ACTION #####################
			
func _enemy_ACT():
	while EntitiesState.enemy_that_can_act == dummy_id and dummy_id not in EntitiesState.enemy_turn_ended_list and dummy_range_entered == true and GameState.is_ennemy_turn:
		EntitiesState.selected_id = EntitiesState.enemy_id
		EntitiesState.take_enemy_action()
		EntitiesState.enemy_selected(get_position())
		await get_tree().create_timer(0.3).timeout
	if dummy_id in GameData.enemy_stats:
		GameData.enemy_stats[dummy_id].MVT = GameData.enemy_stats[dummy_id].MAX_MVT
		GameData.enemy_stats[dummy_id].ACT = GameData.enemy_stats[dummy_id].MAX_ACT
