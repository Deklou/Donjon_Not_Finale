extends Node

#Script se chargeant de tous les états du jeu

#Object States

var chest_states = {} #dictionnaire contenant tous les états des coffres

func chest_is_open(chest_id: String) -> bool: #retourne si l'état est présent, et quel état
	return chest_states.has(chest_id) and chest_states[chest_id]

func open_chest(chest_id: String): #met l'état du coffre ouvert à true
	chest_states[chest_id] = true

#UI_Inventory States

var double_remove_call : bool = false #la fonction remove_button de UI_Inventory est appelée deux fois
var weapon_equipped : bool = false #indique si le joueur a une arme équipée
var weapon_equipped_name: String #le nom de l'arme équipée
var Ui_Inventory_is_locked : bool = false #permet d'interdire à l'interface

#Mouse states

var mouse_select_states : bool = false #utilisé pour déterminer si le joueur a sélectionné une area

#enemy states

var enemy_range_entered : bool = false #on contrôle si le joueur appui sur le bouton d'attaque
var is_ennemy_turn : bool = false #on contrôle si c'est au tour de l'ennemi d'agir, par défaut on le met à vrai car c'est l'ennemi qui attaque en premier

#Player

var player_position : Vector2 #position du joueur

var ending_triggered : bool = false #fin relative à la demo

func player_has_moved(): #c'est ici qu'est régit le comportement des points de mouvements quand le joueur se déplace
	if GameData.player_current_movement_point > 0:
		GameData.player_current_movement_point = GameData.player_current_movement_point - 1
	else:
		GameData.player_current_movement_point = 0
		
func player_has_acted(): #c'est ici qu'est régit le comportement des points d'actions quand le joueur agit
	if GameData.player_current_action_point > 0:
		GameData.player_current_action_point = GameData.player_current_action_point - 1
	else:
		GameData.player_current_action_point = 0

func player_turn_end():
	if not EntitiesState.enemy_triggered_list.is_empty():
		if GameState.is_ennemy_turn == false and GameData.player_current_movement_point == 0 and GameData.player_current_action_point == 0:
			GameState.is_ennemy_turn = true
	else:
		if GameState.is_ennemy_turn == false and GameData.player_current_movement_point == 0:
			GameData.player_current_movement_point = GameData.player_MAX_movement_point
	StatsSystem.update_stats()
	EntitiesState.update_stats.emit()

func enemy_turn_end():
	if GameState.is_ennemy_turn == true:
		GameState.is_ennemy_turn = false
		GameData.turn_number = GameData.turn_number + 1
		GameData.player_current_movement_point = GameData.player_MAX_movement_point
		GameData.player_current_action_point = GameData.player_MAX_action_point
	await get_tree().create_timer(0.5).timeout
	StatsSystem.update_stats()
	EntitiesState.update_stats.emit()
