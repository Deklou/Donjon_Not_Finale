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
@export var enemy_sprite_path : String
@onready var enemy_sprite : Sprite2D = $Sprite2D
@onready var damage_sprite_1 : Sprite2D = $damage_sprite_1 #Sprite temporaire de dégâts
@onready var damage_sprite_2 : Sprite2D = $damage_sprite_2 #Sprite temporaire de dégâts
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var raycast_2D : RayCast2D = $RayCast2D
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
"MAX_ACT" : GameData.enemy_MAX_action_point,
"RANGE" : GameData.enemy_range_state,
"POSITION" : get_position()
}
var dummy_inventory = [] #Inventaire de l'ennemi
var mouse_click_count : int = 0 #Nombre de clics souris pour l'affichage du selecteur
var normalized_enemy_distance : Vector2
var dummy_previous_position : Vector2
var previous_move : Vector2
##################### READY #####################
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
	GameState.enemy_can_act.connect(_enemy_CHOICE)
	Inventory.entity_heal.connect(_dummy_heal)
##################### POSITION #####################
	currPos = $".".position
	currPos.x = round(currPos.x / distance) * distance - 32
	currPos.y = round(currPos.y / distance) * distance - 32
	position = currPos
	GameData.enemy_stats[dummy_id].POSITION = get_position()
##################### SPRITE #####################
	if enemy_sprite_path != "":
		var texture = load(enemy_sprite_path)
		if texture:
			enemy_sprite.texture = texture
##################### INTERFACE ET SELECTEUR #####################
func _on_area_2d_mouse_entered():
	EntitiesState.selected_id = dummy_id
func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true:
		if EntitiesState.selector_position == GameData.enemy_stats[dummy_id].POSITION:
			EntitiesState.enemy_id = dummy_id #Besoin de lier les deux pour cacher le selecteur
			EntitiesState.enemy_is_deselected()
		else:
			EntitiesState.enemy_selected(GameData.enemy_stats[dummy_id].POSITION, dummy_id) #on aeppelle la fonction pour rendre visible l'interface ennemi #on remet l'état à faux pour qu'il ne soit appelé qu'une fois
##################### CONTACT JOUEUR #####################
func _on_area_2d_body_entered(body):
	if body is Node2D:
		GameData.enemy_stats[dummy_id].RANGE  = true
		GameState.enemy_range_entered = true
		EntitiesState.enemy_id = dummy_id
		EntitiesState.selected_id = dummy_id
		EntitiesState.enemy_can_be_attacked_id = dummy_id
		EntitiesState.enemy_can_be_attacked_position = GameData.enemy_stats[dummy_id].POSITION
		EntitiesState.enemy_selected(GameData.enemy_stats[dummy_id].POSITION, dummy_id)		
func _on_area_2d_body_exited(body):
	if body is Node2D and dummy_id in GameData.enemy_stats:
		GameData.enemy_stats[dummy_id].RANGE = false
		GameState.enemy_range_entered = false
		EntitiesState.enemy_is_deselected()
func _on_trigger_range_body_entered(body):
	if body is Node2D:
		EntitiesState.enemy_triggered_list.append(dummy_id)
func _on_trigger_range_body_exited(body):
	if body is Node2D and dummy_id not in EntitiesState.enemy_states:
		EntitiesState.enemy_triggered_list.remove_at(EntitiesState.enemy_triggered_list.find(dummy_id))
		EntitiesState.enemy_is_deselected()
##################### DEGAT #####################
func _entity_take_damage(Entity_Name: String): #Faire une vraie animation dans le futur chef stp
	if !is_inside_tree():
		return 
	if EntitiesState.enemy_can_be_attacked_id == dummy_id and Entity_Name == "Enemy":
		animation_player.play("take_damage")
##################### SOIN #####################
func _dummy_heal(entity_name : String):
	if entity_name == dummy_id:
		animation_player.play("heal")
##################### PROCESS #####################
func _process(_delta):
	if EntitiesState.enemy_is_dead(dummy_id): #Si l'ennemi est vaincu
		$".".queue_free()
		return
##################### CHOIX #####################
func _enemy_CHOICE():
	while EntitiesState.enemy_that_can_act == dummy_id and GameData.enemy_stats[dummy_id].MVT + GameData.enemy_stats[dummy_id].ACT > 0 and dummy_id not in EntitiesState.enemy_turn_ended_list and dummy_id in EntitiesState.enemy_triggered_list and GameState.is_ennemy_turn:
		if !is_inside_tree():
			queue_free()
		if GameData.enemy_stats[dummy_id].RANGE  == true:
			_enemy_ACT()
			await get_tree().create_timer(0.2).timeout
		elif GameData.enemy_stats[dummy_id].MVT > 0:
			_enemy_MVT()
			await get_tree().create_timer(0.1).timeout
		else:
			EntitiesState.enemy_turn_ended_list.append(dummy_id)
		EntitiesState.selector_follows_enemy(GameData.enemy_stats[dummy_id].POSITION)
		StatsSystem.update_stats()
	if dummy_id in GameData.enemy_stats:
		GameData.enemy_stats[dummy_id].MVT = GameData.enemy_stats[dummy_id].MAX_MVT
		GameData.enemy_stats[dummy_id].ACT = GameData.enemy_stats[dummy_id].MAX_ACT
##################### ACTION #####################		
func _enemy_ACT():
	if EntitiesState.enemy_that_can_act == dummy_id and GameData.enemy_stats[dummy_id].ACT > 0 and dummy_id not in EntitiesState.enemy_turn_ended_list and GameData.enemy_stats[dummy_id].RANGE == true and GameState.is_ennemy_turn: 
		EntitiesState.selected_id = EntitiesState.enemy_id
		EntitiesState.take_enemy_action()
		EntitiesState.enemy_selected(GameData.enemy_stats[dummy_id].POSITION, dummy_id)
##################### MOUVEMENT #####################		
func _enemy_MVT():
	if GameState.is_ennemy_turn == true and dummy_id not in EntitiesState.enemy_turn_ended_list:
		normalized_enemy_distance = self.position.direction_to(GameState.player_position)
		dummy_previous_position = self.position
		if abs(normalized_enemy_distance.x) > abs(normalized_enemy_distance.y):
			if normalized_enemy_distance.x > 0:
				_enemy_move(Vector2(distance,0))
			else:
				_enemy_move(Vector2(-distance,0))
		else:
			if normalized_enemy_distance.y > 0:
				_enemy_move(Vector2(0,distance))
			else:
				_enemy_move(Vector2(0,-distance))
		if dummy_previous_position == self.position:
			if previous_move.x == 0:
				_enemy_move(Vector2(sign(normalized_enemy_distance.x)*distance,0))
			elif previous_move.y == 0:
				_enemy_move(Vector2(0,sign(normalized_enemy_distance.y)*distance))
		if dummy_previous_position == self.position:
			EntitiesState.enemy_turn_ended_list.append(dummy_id)
func _enemy_move(_enemy_move_distance: Vector2):
	if !is_inside_tree():
		return 
	previous_move = _enemy_move_distance
	raycast_2D.target_position = _enemy_move_distance
	raycast_2D.force_raycast_update()
	if not raycast_2D.is_colliding():
		self.position += _enemy_move_distance
		GameState.enemy_has_moved()
		GameData.enemy_stats[dummy_id].POSITION = get_position()
##################### PRESENCE ECRAN #####################
func _on_visible_on_screen_notifier_2d_screen_entered(): #Crée une interface liée à l'ennemi
	EntitiesState.enemy_id = dummy_id #l'id dont on se sert pour lier l'ennemi à son interface
	EntitiesState.instanciate_other_UI.emit("enemy") #Vers user_interface
func _on_visible_on_screen_notifier_2d_screen_exited(): #Cache l'interface liée à l'ennemi
	EntitiesState.enemy_id = dummy_id #l'id dont on se sert pour l'interface à supprimer
	EntitiesState.delete_other_UI.emit() #Vers enemy_profil_ui
