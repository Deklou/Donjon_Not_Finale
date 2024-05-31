extends Node2D

@onready var first_room_camera : Camera2D = $"../first_room_camera"
signal to_first_floor 

func _on_to_second_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(0, 704))
	await get_tree().create_timer(0.3).timeout
	first_room_camera.enabled = false
	EntitiesState.enable_player_camera.emit() #vers script joueur
func _on_to_first_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(0, -640))
	await get_tree().create_timer(0.3).timeout
	EntitiesState.disable_player_camera.emit() #vers script joueur
	first_room_camera.enabled = true
func _on_to_third_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(960,-2688))
func _on_to_second_room_from_third_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(-960, 2688))
func _on_to_fourth_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(-1920,768))
func _on_to_third_room_from_fourth_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(1920,-768))
func _on_to_intro_level_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(192, 768))
func _on_to_fourth_room_from_intro_area_2d_2_body_entered(body):
	_move_to_other_room(body,Vector2(-192, -768))
func _on_to_bonus_1_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(-3840, 512))
func _on_to_intro_level_room_from_bonus_1_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(3840, -512))
func _on_to_first_floor_area_2d_body_entered(_body):
	to_first_floor.emit() #vers Root
	queue_free() #A terme, déplacer ce script dans le niveau, pour pouvoir le queue free entièrement
		
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
