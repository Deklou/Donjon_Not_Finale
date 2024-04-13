extends Control

func _on_attack_button_pressed():
	if GameState.enemy_range_entered == true and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		EntitiesState.take_damage_to_enemy("Enemy", EntitiesState.enemy_id)
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()
