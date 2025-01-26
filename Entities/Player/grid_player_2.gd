extends CharacterBody2D

@export var distance = 64 #taille d'une case
@onready var player_sprite_v2 : Sprite2D = $Player_Sprite_V2
@onready var player_camera : Camera2D = $Camera2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
var currPos
var moving_direction = Vector2.ZERO  # Direction actuelle du mouvement
var move_timer = Timer.new()  # Timer pour le mouvement continu
var sprite_tween : Tween
##################### READY #####################
func _ready():
	EntitiesState.player_parent_node = get_parent()
	currPos = $".".position
	currPos.x = round(currPos.x / distance) * distance - 32
	currPos.y = round(currPos.y / distance) * distance - 32
	position = currPos
	move_timer.wait_time = 0.15  # Régler l'intervalle entre les mouvements continus
	move_timer.autostart = false  # Ne pas démarrer automatiquement
	move_timer.one_shot = false  # Répéter le timeout
	add_child(move_timer)
	move_timer.timeout.connect(_on_MoveTimer_timeout)
	##################### SIGNAL #####################
	EntitiesState.take_damage.connect(_player_take_damage)
	EntitiesState.disable_player_camera.connect(_disable_player_moving_camera)
	EntitiesState.enable_player_camera.connect(_enable_player_moving_camera)
	Inventory.entity_heal.connect(_player_heal)
	tween()
##################### DEPLACEMENT #####################
func _input(event):
	if event.is_action("right") or event.is_action("left") or event.is_action("up") or event.is_action("down") or event.is_action("wait"):	
		if EntitiesState.player_is_frozen == false:
			GameState.player_turn_end() #on appelle cette fonction ici car sinon les boutons d'attaque et d'attente apparaissent après avoir bougé
			if event.is_action_pressed("right"):
				moving_direction = Vector2(distance, 0)
				handle_movement(moving_direction, "walk_right_V2")
				move_timer.start()
				tween()
			elif event.is_action_pressed("left"):
				moving_direction = Vector2(-distance, 0)
				handle_movement(moving_direction, "walk_left_V2")
				move_timer.start()
				tween()
			elif event.is_action_pressed("up"):
				moving_direction = Vector2(0, -distance)
				handle_movement(moving_direction, "walk_up_V2")
				move_timer.start()
				tween()
			elif event.is_action_pressed("down"):
				moving_direction = Vector2(0, distance)
				handle_movement(moving_direction, "walk_down_V2")
				move_timer.start()
				tween()
				
			elif event.is_action_pressed("wait"): #raccourcis clavier d'attente ? 
				EntitiesState.player_wait.emit() #Vers Interfacedown
			
			# Arrêter le timer lorsque la touche est relâchée
			if event.is_action_released("right") or event.is_action_released("left") or event.is_action_released("up") or event.is_action_released("down"):
				move_timer.stop()
				moving_direction = Vector2.ZERO  # Réinitialiser la direction
		else:
			move_timer.stop()
			moving_direction = Vector2.ZERO
func _on_MoveTimer_timeout():
	if moving_direction != Vector2.ZERO:
		handle_movement(moving_direction, get_animation_from_direction(moving_direction))
func handle_movement(direction_vector, animation):
	animation_player.play(animation)
	GameState.player_position = self.position
	if not GameState.is_ennemy_turn and GameData.player_current_movement_point > 0:
		$RayCast2D.target_position = direction_vector
		$RayCast2D.force_raycast_update()
		if not $RayCast2D.is_colliding():
			currPos = GameState.player_position + direction_vector
			self.position = currPos
			GameState.player_has_moved()
	elif GameData.player_current_movement_point == 0:
		GameState.player_input_cant_move()
	GameState.player_position = self.position
	tween()
func get_animation_from_direction(direction_vector):
	if direction_vector.x > 0:
		return "walk_right_V2"
	elif direction_vector.x < 0:
		return "walk_left_V2"
	elif direction_vector.y > 0:
		return "walk_down_V2"
	elif direction_vector.y < 0:
		return "walk_up_V2"
##################### TWEEN #####################
func tween(): #besoin de créer le tween et le stopper au même endroit où il est utilisé, d'où la fonction
	sprite_tween = self.create_tween()
	sprite_tween.stop()
	sprite_tween.tween_property(player_sprite_v2, "position", self.position + Vector2(0,-32), 0.2).set_trans(Tween.TRANS_LINEAR)
	sprite_tween.play()
##################### DEGAT #####################
func _player_take_damage(Entity_Name: String):
	if Entity_Name == "Player":
		animation_player.play("take_damage")
	StatsSystem.update_stats()
##################### SOIN #####################
func _player_heal(entity_name : String):
	if entity_name == "Player":
		animation_player.play("heal")
##################### CAMERA #####################
func _disable_player_moving_camera():
	player_camera.enabled = false
func _enable_player_moving_camera():
	player_camera.enabled = true
