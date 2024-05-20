extends Node2D

signal to_the_end 

func _on_to_bonus_2_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(5280, 2848))
func _on_to_bonus_3_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(5600, 1056))
func _on_to_first_floor_from_bonus_2_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(2080, 2592))
func _on_to_first_floor_from_bonus_3_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(4448, 1056))
func _on_to_the_end_area_2d_body_entered(_body):
	to_the_end.emit() #Vers Root

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
