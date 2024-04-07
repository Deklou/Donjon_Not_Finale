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

var player_position : Vector2

var ending_triggered : bool = false

func player_turn_end():
	if GameState.is_ennemy_turn == false:
		GameState.is_ennemy_turn = true

func enemy_turn_end():
	if GameState.is_ennemy_turn == true:
		GameState.is_ennemy_turn = false
		GameData.turn_number = GameData.turn_number + 1
