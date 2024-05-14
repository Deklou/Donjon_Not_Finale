extends Node2D

var teleport_destination : Vector2 = Vector2.ZERO

func _on_to_second_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(352, 1376))

func _on_to_first_room_area_2d_body_entered(body):
	_move_to_other_room(body,Vector2(352, 608))

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

func _move_to_other_room(player : CharacterBody2D, destination : Vector2):
	if player is CharacterBody2D:
		player.global_position = destination
		var currPos = player.global_position
		currPos.x = round(currPos.x / 64) * 64 - 32
		currPos.y = round(currPos.y / 64) * 64 - 32
