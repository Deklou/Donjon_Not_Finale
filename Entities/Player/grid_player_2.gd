extends CharacterBody2D

var currPos
@export var distance = 64 #taille d'une case
var moving_direction = Vector2.ZERO  # Direction actuelle du mouvement
var move_timer = Timer.new()  # Timer pour le mouvement continu

func _ready():
	currPos = $".".position
	move_timer.wait_time = 0.15  # Régler l'intervalle entre les mouvements continus
	move_timer.autostart = false  # Ne pas démarrer automatiquement
	move_timer.one_shot = false  # Répéter le timeout
	add_child(move_timer)
	move_timer.timeout.connect(_on_MoveTimer_timeout)

func _input(event):
	if event.is_action("right") or event.is_action("left") or event.is_action("up") or event.is_action("down"):	
		GameState.player_turn_end() #on appelle cette fonction ici car sinon les boutons d'attaque et d'attente apparaissent après avoir bougé
		if event.is_action_pressed("right"):
			moving_direction = Vector2(distance, 0)
			handle_movement(moving_direction, "walk_right")
			move_timer.start()
		elif event.is_action_pressed("left"):
			moving_direction = Vector2(-distance, 0)
			handle_movement(moving_direction, "walk_left")
			move_timer.start()
		elif event.is_action_pressed("up"):
			moving_direction = Vector2(0, -distance)
			handle_movement(moving_direction, "walk_up")
			move_timer.start()
		elif event.is_action_pressed("down"):
			moving_direction = Vector2(0, distance)
			handle_movement(moving_direction, "walk_down")
			move_timer.start()
		
		# Arrêter le timer lorsque la touche est relâchée
		if event.is_action_released("right") or event.is_action_released("left") or event.is_action_released("up") or event.is_action_released("down"):
			move_timer.stop()
			moving_direction = Vector2.ZERO  # Réinitialiser la direction


func _on_MoveTimer_timeout():
	if moving_direction != Vector2.ZERO:
		handle_movement(moving_direction, get_animation_from_direction(moving_direction))

func handle_movement(direction_vector, animation):
	$AnimationPlayer.play(animation)
	if not GameState.is_ennemy_turn and GameData.player_current_movement_point > 0:
		$RayCast2D.target_position = direction_vector
		$RayCast2D.force_raycast_update()
		if not $RayCast2D.is_colliding():
			currPos += direction_vector
			self.position = currPos
			GameState.player_has_moved()
	GameState.player_position = self.position

func get_animation_from_direction(direction_vector):
	if direction_vector.x > 0:
		return "walk_right"
	elif direction_vector.x < 0:
		return "walk_left"
	elif direction_vector.y > 0:
		return "walk_down"
	elif direction_vector.y < 0:
		return "walk_up"
