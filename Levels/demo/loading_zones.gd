extends Node2D

@onready var first_room_camera : Camera2D = $"../first_room_camera"

func _on_to_second_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(352, 1376))
	await get_tree().create_timer(0.3).timeout
	first_room_camera.enabled = false
	EntitiesState.enable_player_camera.emit() #vers script joueur
func _on_to_first_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(352, 608))
	await get_tree().create_timer(0.3).timeout
	EntitiesState.disable_player_camera.emit() #vers script joueur
	first_room_camera.enabled = true
func _on_to_third_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(1312, 224))
func _on_to_second_room_from_third_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(352, 2336))
func _on_to_fourth_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(1312, 1376))
func _on_to_third_room_from_fourth_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(3104, 608))
func _on_to_intro_level_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(3488, 2080))
func _on_to_fourth_room_from_intro_area_2d_2_body_entered(body):
	_move_to_other_room(body,Vector2(3104, 1312))
func _on_to_bonus_1_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(2016, 2592))
func _on_to_intro_level_room_from_bonus_1_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(5856, 2272))
	
func _move_to_other_room(player : CharacterBody2D, destination : Vector2):
	if player is CharacterBody2D:
		var transition_scene = preload("res://Transition/_to_another_room.tscn").instantiate()
		var animation_player_fade_in = transition_scene.get_node("black_color_rect/AnimationPlayer_Fade")
		var currPos = player.global_position
		EntitiesState.player_parent_node.add_child(transition_scene)
		animation_player_fade_in.play("fade_out")
		EntitiesState.player_is_frozen = true
		await get_tree().create_timer(0.3).timeout
		player.global_position = destination
		currPos.x = round(currPos.x / 64) * 64 - 32
		currPos.y = round(currPos.y / 64) * 64 - 32
		await get_tree().create_timer(0.3).timeout
		animation_player_fade_in.play("fade_in")
		EntitiesState.player_is_frozen = false
		EntitiesState.player_parent_node.remove_child(transition_scene)
		transition_scene.queue_free()
