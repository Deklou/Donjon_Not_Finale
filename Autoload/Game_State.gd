extends Node

##################### VARIABLE PAR DEFAUT #####################
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
##################### VARIABLES #####################
#Object States
var chest_states = {} #dictionnaire contenant tous les états des coffres
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
signal range_check #vérifie si le joueur se trouve ciblé par un ennemi
signal combat_check #vérifie si le joueur a la porté d'attaquer un ennemi
signal hide_wait_button #cache le bouton d'attente
signal hide_attack_button #cache le bouton d'attaque
signal show_mvt_act_stats #cache les stats de mvt et act si le joueur n'est pas en combat
signal enemy_can_act #signal lancé au script de l'ennemi pour lui faire choisir une action
signal signal_player_input_cant_move #lorsque le joueur veut se déplacer alors qu'il n'a plus de point de mouvement
signal restart_root #recharge le début de Root
signal tutorial_start #met à jour l'interface si le joueur commence le tuto
##################### RESET VALUE #####################
func _reset_gamestate_value():
	chest_states.clear()
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
	if GameData.player_current_movement_point > 0:
		GameData.player_current_movement_point = GameData.player_current_movement_point - 1
	else:
		GameData.player_current_movement_point = 0
		
func player_input_cant_move():
	signal_player_input_cant_move.emit() #envoi vers Player_Profil_UI
		
func player_has_acted(): #c'est ici qu'est régit le comportement des points d'actions quand le joueur agit
	if GameData.player_current_action_point > 0:
		GameData.player_current_action_point = GameData.player_current_action_point - 1
	else:
		GameData.player_current_action_point = 0

func player_turn_end():
	range_check.emit() #envoi à interface down
	combat_check.emit() #envoi à interface down
	if GameData.player_current_action_point == 0:
		hide_attack_button.emit()
	if not EntitiesState.enemy_triggered_list.is_empty():
		if GameState.is_ennemy_turn == false and GameData.player_current_movement_point == 0 and GameData.player_current_action_point == 0:
			GameState.is_ennemy_turn = true
			hide_wait_button.emit()
			for i in EntitiesState.enemy_triggered_list:
				EntitiesState.enemy_that_can_act = i
				EntitiesState.enemy_id = EntitiesState.enemy_that_can_act
				enemy_can_act.emit() #Vers les scripts ennemis
				await get_tree().create_timer(float(GameData.enemy_stats[EntitiesState.enemy_that_can_act].MAX_ACT/1.9)).timeout #On attend en fonction du nombre d'action de l'ennemi
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
	range_check.emit() #envoi à interface down
	combat_check.emit() #envoi à interface down
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
	var scene = EntitiesState.Root.get_node("./Game_Over")
	EntitiesState.Root.remove_child.call_deferred(scene)
	scene.queue_free()
	scene = EntitiesState.Root.get_node("./Root/User_Interface")
	EntitiesState.Root.get_node("Root").remove_child.call_deferred(scene)
	scene.queue_free()
	EntitiesState.Root.get_node("Root").add_child.call_deferred(preload("res://UI/user_interface.tscn").instantiate())
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
