extends CharacterBody2D


var currPos
@export var distance = 64 #taille d'une case

func _ready():
	currPos = $".".position

func _input(event):
	if GameState.is_ennemy_turn == false and GameData.player_current_movement_point > 0:
		if event.is_action_pressed("right"):
			$AnimationPlayer.play("walk_right")
			$RayCast2D.target_position = Vector2(distance,0)
			$RayCast2D.force_raycast_update()
			if not $RayCast2D.is_colliding():
				currPos.x += distance
				self.position = Vector2(currPos.x,currPos.y)
				GameState.player_has_moved()
				GameState.player_turn_end()
		elif event.is_action_pressed("left"):
			$AnimationPlayer.play("walk_left")
			$RayCast2D.target_position = Vector2(-distance,0)
			$RayCast2D.force_raycast_update()
			if not $RayCast2D.is_colliding():
				currPos.x -= distance
				self.position = Vector2(currPos.x,currPos.y)
				GameState.player_has_moved()
				GameState.player_turn_end()
		elif event.is_action_pressed("up"):
			$AnimationPlayer.play("walk_up")
			$RayCast2D.target_position = Vector2(0,-distance)
			$RayCast2D.force_raycast_update()
			if not $RayCast2D.is_colliding():
				currPos.y -= distance
				$AnimationPlayer.play("walk_up")
				self.position = Vector2(currPos.x,currPos.y)
				GameState.player_has_moved()
				GameState.player_turn_end()
		elif event.is_action_pressed("down"):
			$AnimationPlayer.play("walk_down")
			$RayCast2D.target_position = Vector2(0,distance)
			$RayCast2D.force_raycast_update()
			if not $RayCast2D.is_colliding():
				currPos.y += distance
				self.position = Vector2(currPos.x,currPos.y)
				GameState.player_has_moved()
				GameState.player_turn_end()
		GameState.player_position = self.position
