extends Control

func _ready():
	GameState.show_attack_button.connect(player_has_entered_combat)

func _on_attack_button_pressed():
	if GameState.enemy_range_entered == true and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		EntitiesState.take_damage_to_enemy("Enemy", EntitiesState.enemy_id)
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()
	
func player_has_entered_combat():
	if not EntitiesState.enemy_triggered_list.is_empty():
		$HBoxContainer/Attack_button.visible = true
	else:
		$HBoxContainer/Attack_button.visible = false
