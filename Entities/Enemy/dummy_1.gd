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
var normalized_enemy_distance : Vector2 #Vector modélisant la distance entre le joueur et l'ennemi
var entity_targeted : bool = false
var dummy_range_entered : bool = false 
var dummy_previous_position : Vector2

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

func _process(_delta):
	
	if GameState.mouse_select_states == true: #si la souris se trouve dans la zone de l'ennemi
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true and EntitiesState.selected_id == dummy_id: #si le joueur appui sur clic gauche
				EntitiesState.enemy_selected() #on aeppelle la fonction pour rendre visible l'interface ennemi
				GameState.mouse_select_states = false #on remet l'état à faux pour qu'il ne soit appelé qu'une fois
	
	if EntitiesState.enemy_is_dead(dummy_id): #Si l'ennemi est vaincu
		XpSystem.gain_xp()
		$".".queue_free()
		GameData.enemy_stats.erase(dummy_id) #Une fois qu'on a supprimé l'ennemi du niveau, on supprime sa clé et valeur dans le dictionnaire de stats
		GameData.enemy_inventory.erase(dummy_id) #Une fois qu'on a supprimé l'ennemi du niveau, on supprime son inventaire
		return
			
	if GameState.is_ennemy_turn == true and dummy_id not in EntitiesState.enemy_turn_ended_list:	
			
			
		if dummy_range_entered == true and GameState.is_ennemy_turn == true and EntitiesState.selected_id == dummy_id: #si le joueur entre en contact avec l'ennemi et que c'est au tour de l'ennemi, l'ennemi attaque le joueur
			EntitiesState.selected_id = EntitiesState.enemy_id #Pour s'assurer de la cohérence entre l'affichage et les datas
			EntitiesState.enemy_selected() #Si on entre en contact avec un ennemi, c'est son interface qui s'affichera
			EntitiesState.take_enemy_action()
			
		if dummy_id in  EntitiesState.enemy_triggered_list and GameState.is_ennemy_turn == true and dummy_id not in EntitiesState.enemy_turn_ended_list:
			_enemy_movement()
			if dummy_previous_position == self.position and dummy_id not in EntitiesState.enemy_turn_ended_list:
				EntitiesState.enemy_turn_ended_list.append(dummy_id)
				if dummy_range_entered == true: 
					EntitiesState.take_enemy_action() 
		
		if EntitiesState.enemy_triggered_list.is_empty(): #faire passer le tour quand aucun ennemi n'a été trigger
			GameState.enemy_turn_end()
			
		if len(EntitiesState.enemy_triggered_list) == len(EntitiesState.enemy_turn_ended_list):
			EntitiesState.enemy_turn_ended_list.clear()
			GameState.enemy_turn_end()
		
#si un body entre et sort de l'area

func _on_area_2d_body_entered(body): 
	if body is Node2D:
		dummy_range_entered = true
		GameState.enemy_range_entered = true
		EntitiesState.enemy_id = dummy_id
		EntitiesState.selected_id = EntitiesState.enemy_id
	
func _on_area_2d_body_exited(body):
	if body is Node2D:
		dummy_range_entered = false 
		GameState.enemy_range_entered = false

#update l'état de la souris (à l'intérieur de la zone ou non) 

func _on_area_2d_mouse_entered():
	GameState.mouse_select_states = true
	EntitiesState.selected_id = dummy_id

func _on_area_2d_mouse_exited():
	GameState.mouse_select_states = false


func _on_trigger_range_body_entered(body):
	if body is Node2D:
		entity_targeted = true
		EntitiesState.enemy_triggered_list.append(dummy_id)
		
func _on_trigger_range_body_exited(body):
	if body is Node2D:
		entity_targeted = false
		EntitiesState.enemy_triggered_list.remove_at(EntitiesState.enemy_triggered_list.find(dummy_id))

func _enemy_movement():
	if GameState.is_ennemy_turn == true and dummy_id not in EntitiesState.enemy_turn_ended_list:	
		normalized_enemy_distance = self.position.direction_to(GameState.player_position)
		dummy_previous_position = self.position
		if abs(normalized_enemy_distance.x) > abs(normalized_enemy_distance.y):
			if normalized_enemy_distance.x > 0:
				$RayCast2D.target_position = Vector2(64,0)
				$RayCast2D.force_raycast_update()
				if not $RayCast2D.is_colliding():
					self.position += Vector2(64,0)
					EntitiesState.enemy_turn_ended_list.append(dummy_id)
			else:
				$RayCast2D.target_position = Vector2(-64,0)
				$RayCast2D.force_raycast_update()
				if not $RayCast2D.is_colliding():
					self.position += Vector2(-64,0)
					EntitiesState.enemy_turn_ended_list.append(dummy_id)
		else:
			if normalized_enemy_distance.y > 0:
				$RayCast2D.target_position = Vector2(0,64)
				$RayCast2D.force_raycast_update()
				if not $RayCast2D.is_colliding():
					self.position += Vector2(0,64)
					EntitiesState.enemy_turn_ended_list.append(dummy_id)
			else:
				$RayCast2D.target_position = Vector2(0,-64)
				$RayCast2D.force_raycast_update()
				if not $RayCast2D.is_colliding():
					self.position += Vector2(0,-64)
					EntitiesState.enemy_turn_ended_list.append(dummy_id)
