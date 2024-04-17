extends Control

@onready var attack_button  : Button = $HBoxContainer/Attack_button
@onready var wait_button  : Button = $HBoxContainer/Wait_button

func _ready():
	GameState.show_wait_button.connect(player_has_entered_combat)
	GameState.show_attack_button.connect(player_has_entered_enemy_range)
	
func _on_wait_button_pressed():
	GameData.player_current_action_point = 0
	GameData.player_current_movement_point = 0
	StatsSystem.update_stats()
	GameState.player_turn_end()
	
func player_has_entered_combat():
	if not EntitiesState.enemy_triggered_list.is_empty():
		wait_button.visible = true
	else:
		wait_button.visible = false

func player_has_entered_enemy_range():
	if not EntitiesState.enemy_triggered_list.is_empty() and GameState.enemy_range_entered == true: 
		attack_button.visible = true
	else:
		attack_button.visible = false

func _on_attack_button_pressed():
	if GameState.enemy_range_entered == true and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		EntitiesState.take_damage_to_enemy("Enemy", EntitiesState.enemy_id)
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()
