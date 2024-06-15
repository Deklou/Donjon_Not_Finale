extends Node

##################### VARIABLE PAR DEFAUT #####################
var default_fountain_id : int = 0
var default_fountain_current_point : int = 0
var default_double_remove_call : bool = false
var default_weapon_equipped : bool = false
var default_weapon_equipped_name : String = ""
var default_Ui_Inventory_is_locked : bool = false
var default_mouse_select_states : bool = false
var default_enemy_range_entered : bool = false
var default_is_ennemy_turn : bool = false
var default_player_position : Vector2 = Vector2()
var default_ending_triggered : bool = false
var default_level_up : bool = false #Exception pour ne pas mettre à jour le texte de niveau dans update_player_UI
var default_first_enemy_defeated : bool = false
var default_first_weapon_equiped : bool = false
var default_silent_presence_log : bool = false
var default_fountain_is_currently_used : bool = false #check si le joeuur est actuellement en train d'utiliser une fontaine
var default_kojiro_was_obtained : bool = false
var default_auto_turn_enabled : bool = false
var default_debug_enabled : bool = false
##################### VARIABLES #####################
#Object States
var chest_states = {} #dictionnaire contenant tous les états des coffres
var fountain_id : int #identifiant unique d'une fontaine
var fountain_current_point : int #les points restants de la fontaine
var fountain_attributes = {} #dictionnaire contenant tous les attributs d'une fontaine
var fountain_states = [] #tableau contenant les fontaines déjà utilisées
# UI_Inventory States
var double_remove_call : bool #la fonction remove_button de UI_Inventory est appelée deux fois
var weapon_equipped : bool #indique si le joueur a une arme équipée
var weapon_equipped_name : String #le nom de l'arme équipée
var Ui_Inventory_is_locked : bool #permet d'interdire à l'interface
# Mouse states
var mouse_select_states : bool #utilisé pour déterminer si le joueur a sélectionné une area
# Enemy states
var enemy_range_entered : bool #on contrôle si le joueur appui sur le bouton d'attaque
var is_ennemy_turn : bool #on contrôle si c'est au tour de l'ennemi d'agir, par défaut on le met à vrai car c'est l'ennemi qui attaque en premier
# Player
var player_position : Vector2 #position du joueur
var ending_triggered : bool #fin relative à la demo
var level_up : bool #Exception pour ne pas mettre à jour le texte de niveau dans update_player_UI
var first_enemy_defeated : bool
var first_weapon_equiped : bool
var silent_presence_log : bool
var fountain_is_currently_used : bool
var kojiro_was_obtained : bool
var auto_turn_enabled : bool #dicte si le passage automatique du tour est activé
var debug_enabled : bool #dicte si le debug mode peut être acitvée
signal range_check #vérifie si le joueur se trouve ciblé par un ennemi
signal combat_check #vérifie si le joueur a la porté d'attaquer un ennemi
signal hide_wait_button #cache le bouton d'attente
signal hide_attack_button #cache le bouton d'attaque
signal show_mvt_act_stats #cache les stats de mvt et act si le joueur n'est pas en combat
signal enemy_can_act #signal lancé au script de l'ennemi pour lui faire choisir une action
signal signal_player_input_cant_move #lorsque le joueur veut se déplacer alors qu'il n'a plus de point de mouvement
signal restart_root #recharge le début de Root
signal tutorial_start #met à jour l'interface si le joueur commence le tuto
signal tutorial_end #affiche l'interface finale 
signal intro_level_closed_door #fait apparaître la porte fermée au premier niveau
signal fountain_has_been_used(fountain_id) #quand une fontaine a été utilisé, on envoie un signal pour checker son apparence
signal to_stats_screen
signal to_game_from_menu #utilisé lorsque l'on souhaite revenir au jeu à partir d'un menu
##################### RESET VALUE #####################
func _reset_gamestate_value():
	chest_states.clear()
	fountain_attributes.clear()
	fountain_states.clear()
	fountain_id = default_fountain_id
	fountain_current_point = default_fountain_current_point
	double_remove_call = default_double_remove_call
	weapon_equipped = default_weapon_equipped
	weapon_equipped_name = default_weapon_equipped_name
	Ui_Inventory_is_locked = default_Ui_Inventory_is_locked
	mouse_select_states = default_mouse_select_states
	enemy_range_entered = default_enemy_range_entered
	is_ennemy_turn = default_is_ennemy_turn
	player_position = default_player_position
	ending_triggered = default_ending_triggered
	level_up = default_level_up
	first_enemy_defeated = default_first_enemy_defeated
	first_weapon_equiped = default_first_weapon_equiped
	silent_presence_log = default_silent_presence_log
	fountain_is_currently_used = default_fountain_is_currently_used
	kojiro_was_obtained = default_kojiro_was_obtained
	auto_turn_enabled = default_auto_turn_enabled
	debug_enabled = default_debug_enabled
##################### READY #####################
func _ready():
	_reset_gamestate_value()
##################### FONCTIONS #####################

func chest_is_open(chest_id: String) -> bool: #retourne si l'état est présent, et quel état
	return chest_states.has(chest_id) and chest_states[chest_id]

func open_chest(chest_id: String): #met l'état du coffre ouvert à true
	chest_states[chest_id] = true

##################### JOUEUR #####################

func player_has_moved(): #c'est ici qu'est régit le comportement des points de mouvements quand le joueur se déplace
	if not EntitiesState.enemy_triggered_list.is_empty():
		if GameData.player_current_movement_point > 0:
			GameData.player_current_movement_point = GameData.player_current_movement_point - 1
		else:
			GameData.player_current_movement_point = 0
		
func player_input_cant_move():
	if GameState.auto_turn_enabled == true and GameState.enemy_range_entered == false: #Si l'autoturn est activé et qu'on ne peut attaquer, alors on passe le tour
		GameData.player_current_action_point = 0
		player_turn_end()
	signal_player_input_cant_move.emit() #envoi vers Player_Profil_UI
		
func player_has_acted(): #c'est ici qu'est régit le comportement des points d'actions quand le joueur agit
	if GameData.player_current_action_point > 0:
		GameData.player_current_action_point = GameData.player_current_action_point - 1
	else:
		GameData.player_current_action_point = 0

func player_turn_end():
	if GameData.player_current_action_point == 0:
		hide_attack_button.emit()
	if not EntitiesState.enemy_triggered_list.is_empty():
		if GameState.is_ennemy_turn == false and GameData.player_current_movement_point == 0 and GameData.player_current_action_point == 0:
			GameState.is_ennemy_turn = true
			hide_wait_button.emit()
			for i in EntitiesState.enemy_triggered_list:
				EntitiesState.enemy_that_can_act = i
				EntitiesState.enemy_id = EntitiesState.enemy_that_can_act
				if EntitiesState.enemy_id in GameData.enemy_stats:
					enemy_can_act.emit() #Vers les scripts ennemis
					await get_tree().create_timer(float(GameData.enemy_stats[EntitiesState.enemy_that_can_act].MAX_ACT*0.2 + GameData.enemy_stats[EntitiesState.enemy_that_can_act].MAX_MVT*0.1)).timeout #On attend en fonction du nombre d'action et de mouvement de l'ennemi
			if EntitiesState.enemy_triggered_list == EntitiesState.enemy_turn_ended_list:
				EntitiesState.enemy_turn_ended_list.clear()
				GameState.enemy_turn_end()
	else:
		if GameState.is_ennemy_turn == false:
			if GameData.player_current_movement_point == 0:
				GameData.player_current_movement_point = GameData.player_MAX_movement_point
			elif GameData.player_current_action_point == 0:
				GameData.player_current_action_point = GameData.player_MAX_action_point
	show_mvt_act_stats.emit() #envoi vers Player_profil_UI
	StatsSystem.update_stats()
	
##################### ENNEMI #####################

func enemy_has_moved(): #c'est ici qu'est régit le comportement des points de mouvements quand l'ennemi se déplace
	if GameData.enemy_stats[EntitiesState.enemy_that_can_act].MVT > 0:
		GameData.enemy_stats[EntitiesState.enemy_that_can_act].MVT = GameData.enemy_stats[EntitiesState.enemy_that_can_act].MVT - 1
	else:
		GameData.enemy_stats[EntitiesState.enemy_that_can_act].MVT = 0
		
func enemy_has_acted(): #c'est ici qu'est régit le comportement des points d'actions quand l'ennemi joueur agit
	if GameData.enemy_stats[EntitiesState.enemy_that_can_act].ACT > 0:
		GameData.enemy_stats[EntitiesState.enemy_that_can_act].ACT = GameData.enemy_stats[EntitiesState.enemy_that_can_act].ACT - 1
	else:
		GameData.enemy_stats[EntitiesState.enemy_that_can_act].ACT = 0

func enemy_turn_end():
	if GameState.is_ennemy_turn == true:
		GameState.is_ennemy_turn = false
		GameData.turn_number = GameData.turn_number + 1
		GameData.player_current_movement_point = GameData.player_MAX_movement_point
		GameData.player_current_action_point = GameData.player_MAX_action_point
	StatsSystem.update_stats()

##################### RESTART #####################
	
func restart_game():
	EntitiesState.Root = get_tree().root
	EntitiesState.Root.remove_child.call_deferred(EntitiesState.player_parent_node)
	EntitiesState.player_parent_node.queue_free()
	var scene = EntitiesState.Root.get_node("./Game_Over")
	EntitiesState.Root.remove_child.call_deferred(scene)
	scene.queue_free()
	for child in EntitiesState.Root.get_node("Root").get_children(): #je fais ça car il arrive que l'interface change de nom dans l'arbre...
		EntitiesState.Root.get_node("Root").remove_child.call_deferred(child)
		child.queue_free()
	scene = EntitiesState.Root.get_node("./Camera_Death")
	scene.queue_free()
	EntitiesState._reset_entities_state_value()
	GameData._reset_gamedata_value()
	GameState._reset_gamestate_value()
	Inventory._reset_inventory_value()
	Logs._reset_logs_value()
	StatsSystem._reset_stats_system_value()
	StatsSystem.update_stats()
	restart_root.emit()

func reload_game():
	EntitiesState.Root = get_tree().root
	if EntitiesState.player_parent_node != null:
		if EntitiesState.player_parent_node.is_inside_tree():
			EntitiesState.Root.remove_child.call_deferred(EntitiesState.player_parent_node)
			EntitiesState.player_parent_node.queue_free()
	EntitiesState._reset_entities_state_value()
	GameData._reset_gamedata_value()
	GameState._reset_gamestate_value()
	Inventory._reset_inventory_value()
	Logs._reset_logs_value()
	StatsSystem._reset_stats_system_value()
	StatsSystem.update_stats()
