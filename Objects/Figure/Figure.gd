extends Node2D

@onready var figure_animation_player : AnimationPlayer = $ColorRect_Animation/AnimationPlayer_Fade
@export var distance = 64 #taille d'une case
@export var num_cases = 8 # nombre de cases de distance du joueur
@onready var raycast : RayCast2D = $RayCast2D
var currPos
var animation_is_triggered : bool = false
var move_timer : Timer

func _ready():
	currPos = $".".position
	currPos.x = round(currPos.x / distance) * distance - 32
	currPos.y = round(currPos.y / distance) * distance - 32
	position = currPos
	move_timer = Timer.new()
	move_timer.wait_time = GameData.enemy_defeated + 1
	move_timer.one_shot = false
	move_timer.timeout.connect(adjust_position_to_valid_case)
	add_child(move_timer)
	move_timer.start()

func adjust_position_to_valid_case():
	if EntitiesState.player_parent_node.get_node("Grid_player_2"):
		var player_position = EntitiesState.player_parent_node.get_node("Grid_player_2").position
		var directions = [
			Vector2(num_cases * distance, 0),  # Droite
			Vector2(-num_cases * distance, 0), # Gauche
			Vector2(0, num_cases * distance),  # Bas
			Vector2(0, -num_cases * distance)  # Haut
		]
		directions.shuffle()
		for direction in directions:
			var target_position = player_position + direction
			raycast.global_position = player_position
			raycast.force_raycast_update()
			if not raycast.is_colliding():
				position = target_position

func _on_trigger_area_2d_body_entered(body):
	if body is Node2D and animation_is_triggered == false:
		animation_is_triggered = true
		figure_animation_player.play("fade_in")
		await get_tree().create_timer(3.0).timeout
		queue_free()

