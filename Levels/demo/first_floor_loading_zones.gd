extends Node2D

@onready var secret_exit_area_2d : Area2D = $to_secret_area_2d
@onready var demo_tilemap : TileMap = $"../Demo_TileMap"
var no_enemy_left : bool = false
signal to_secret_exit
signal to_tutorial_from_first_floor
##################### READY  #####################
func _ready():
	demo_tilemap.set_layer_enabled(0, true) #par défaut on active les collisions
	EntitiesState.enemy_is_deselected()
	StatsSystem.update_player_stats.connect(_all_enemies_are_defeated)
##################### LOADING ZONE  #####################	
func _on_to_bonus_2_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(3200, 320))
func _on_to_bonus_3_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(1088, 0))
func _on_to_first_floor_from_bonus_2_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(-3200, -320))
func _on_to_first_floor_from_bonus_3_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(-1088, 0))
func _on_to_the_end_area_2d_body_entered(_body):
	demo_tilemap.set_layer_enabled(0, false) #par défaut on active les collisions
	print("first floor loading zones.gd trigger fin")
	GameState.to_stats_screen.emit() #Vers Root
func _on_to_secret_area_2d_body_entered(_body):
	demo_tilemap.set_layer_enabled(0, false) #par défaut on active les collisions
	to_secret_exit.emit() #vers Root
func _on_to_intro_level_area_2d_body_entered(_body):
	demo_tilemap.set_layer_enabled(0, false) #par défaut on active les collisions
	to_tutorial_from_first_floor.emit() #Vers Root
func _move_to_other_room(player : CharacterBody2D, destination : Vector2):
	if player is CharacterBody2D:
		var transition_scene = preload("res://Transition/_to_another_room.tscn").instantiate()
		var animation_player_fade_in = transition_scene.get_node("black_color_rect/AnimationPlayer_Fade")
		var currPos = player.global_position
		EntitiesState.player_parent_node.add_child(transition_scene)
		animation_player_fade_in.play("fade_out")
		EntitiesState.player_is_frozen = true
		await get_tree().create_timer(0.3).timeout
		player.global_position += destination
		currPos.x = round(currPos.x / 64) * 64 - 32
		currPos.y = round(currPos.y / 64) * 64 - 32
		await get_tree().create_timer(0.3).timeout
		animation_player_fade_in.play("fade_in")
		EntitiesState.player_is_frozen = false
		EntitiesState.player_parent_node.remove_child(transition_scene)
		transition_scene.queue_free()
##################### ENNEMIS VAINCU  #####################
func _all_enemies_are_defeated():
	if EntitiesState.player_parent_node != null and no_enemy_left == false and is_inside_tree():
		if EntitiesState.player_parent_node.get_node("Enemies").get_child_count() == 0:
			no_enemy_left = true
			await get_tree().create_timer(2.0).timeout
			Logs._add_log("Un silence assourdissant\nenvahi la salle.")
			EntitiesState.player_parent_node.add_child(preload("res://Objects/Figure/Figure.tscn").instantiate())
			secret_exit_area_2d.position = Vector2(416, 352)
			await get_tree().create_timer(4.0).timeout
			EntitiesState.player_parent_node.add_child(preload("res://Objects/Figure/Figure.tscn").instantiate())
