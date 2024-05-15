extends Node2D

var first_fall : bool = true
var inventory_acquired : bool = false

func _ready():
	GameState.tutorial_start.emit() #vers user_interface
	EntitiesState.disable_player_camera.emit() #vers script joueur

func _on_fall_area_2d_body_entered(body):
	if body is CharacterBody2D:
		for i in range (1,(2016 - body.global_position.y)/64):
			body.global_position = body.global_position + Vector2(0,64)
			await get_tree().create_timer(0.08-0.01*i).timeout
	if first_fall == true:
		GameData.player_HP_buffer = int(GameData.player_HP/5.0)
		EntitiesState.take_damage.emit("Player") #Envoi vers script joueur
		first_fall = false
		
func _on_inventory_log_area_2d_body_entered(_body):
	if inventory_acquired == false:
		Logs._add_log("Vous avez trouvé un\nbaluchon. Vous avez du\nmal à en distinguer\nle fond.")
		inventory_acquired = true
		
func _on_ui_hide_enemy_hp_area_2d_body_entered(_body):
	EntitiesState.hide_enemy_hp_stat_UI.emit() #vers user_interface
func _on_ui_hide_enemy_hp_area_2d_body_exited(_body):
	EntitiesState.show_enemy_hp_stat_UI.emit() #vers user_interface

func _on_ui_show_str_area_2d_body_entered(_body):
	EntitiesState.show_str_stat_UI.emit() #vers user_interface

func _on_ui_show_def_area_2d_body_entered(_body):
	EntitiesState.show_def_stat_UI.emit() #vers user_interface
