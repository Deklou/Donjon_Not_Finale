extends Control

@onready var attack_button  : Button = $Attack_button
@onready var wait_button  : Button = $Wait_button
##################### READY #####################
func _ready():
	GameState.range_check.connect(player_has_entered_enemy_range)
	GameState.combat_check.connect(player_has_entered_combat)
	GameState.hide_wait_button.connect(hide_wait_button)
	GameState.hide_attack_button.connect(hide_attack_button)
	EntitiesState.player_wait.connect(_on_wait_button_pressed)
	GameState.to_game_from_menu.connect(_back_to_game_from_command)
##################### BOUTON ATTENTE #####################	
func _on_wait_button_pressed():
	GameData.player_current_action_point = 0
	GameData.player_current_movement_point = 0
	StatsSystem.update_stats()
	GameState.player_turn_end()
func player_has_entered_enemy_range():
	if not EntitiesState.enemy_triggered_list.is_empty():
		wait_button.visible = true
	else:
		wait_button.visible = false
##################### BOUTON ATTAQUE #####################
func player_has_entered_combat():
	if not EntitiesState.enemy_triggered_list.is_empty() and GameState.enemy_range_entered == true and GameData.player_current_action_point > 0: 
		attack_button.visible = true
	else:
		attack_button.visible = false
##################### CACHER #####################		
func hide_wait_button():
	wait_button.visible = false
func hide_attack_button():
	attack_button.visible = false
##################### ATTAQUE #####################
func _on_attack_button_pressed():
	if not EntitiesState.enemy_can_be_attacked_id in GameData.enemy_stats:
		if not EntitiesState.enemy_triggered_list.is_empty():
			EntitiesState.enemy_can_be_attacked_id = EntitiesState.enemy_triggered_list[0]
			EntitiesState.selected_id = EntitiesState.enemy_can_be_attacked_id
	if GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		if GameData.enemy_stats[EntitiesState.selected_id].RANGE == true:
			if EntitiesState.selected_id != EntitiesState.enemy_can_be_attacked_id:
				EntitiesState.enemy_can_be_attacked_id = EntitiesState.selected_id 
			else:
				EntitiesState.selected_id = EntitiesState.enemy_can_be_attacked_id
		EntitiesState.enemy_id = EntitiesState.selected_id
		EntitiesState.enemy_can_be_attacked_position = GameData.enemy_stats[EntitiesState.enemy_can_be_attacked_id].POSITION
		EntitiesState.enemy_selected(EntitiesState.enemy_can_be_attacked_position, EntitiesState.enemy_can_be_attacked_id)
		EntitiesState.take_damage_to_enemy("Enemy", EntitiesState.enemy_can_be_attacked_id)
		GameState.player_has_acted()
		GameState.player_turn_end()
		StatsSystem.update_stats()
##################### BOUTON COMMANDES #####################
func _on_command_button_pressed():
	EntitiesState.player_is_frozen = true
	EntitiesState.Root = get_tree().root
	EntitiesState.player_parent_node.visible = false
	if EntitiesState.Root.get_node("Root").get_child_count() > 0:
		EntitiesState.Root.get_node("Root").get_child(0).visible = false #l'interface
	EntitiesState.Root.add_child.call_deferred(preload("res://Menu/Command_Screen/Command_Screen.tscn").instantiate())
func _back_to_game_from_command():
	if EntitiesState.player_parent_node != null:
		EntitiesState.player_is_frozen = false
		EntitiesState.player_parent_node.visible = true
		if EntitiesState.Root.get_node("Root").get_child_count() > 0:
			EntitiesState.Root.get_node("Root").get_child(0).visible = true #l'interface
