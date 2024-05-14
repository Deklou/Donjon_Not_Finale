extends Node2D

var teleport_destination : Vector2 = Vector2.ZERO

func _on_to_second_room_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.global_position = Vector2(352, 1376)
		var currPos = body.global_position
		currPos.x = round(currPos.x / 64) * 64 - 32
		currPos.y = round(currPos.y / 64) * 64 - 32
