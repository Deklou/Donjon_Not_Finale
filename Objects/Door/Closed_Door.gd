extends Node2D

@onready var animation_player : AnimationPlayer = $ColorRect_Animation/AnimationPlayer_Fade
@onready var collision_shape_2d : CollisionShape2D = $closed_door_sprite_2d/closed_door_area_2d/closed_door_collision_shape_2D
@onready var closed_door_sprite_2d : Sprite2D = $closed_door_sprite_2d

func _ready():
	closed_door_sprite_2d.visible = false
	collision_shape_2d.disabled = true
	GameState.intro_level_closed_door.connect(_closed_door_appearance)
	
func _closed_door_appearance():
	if GameState.first_weapon_equiped == true and GameState.silent_presence_log == true:
		animation_player.play("fade_in")
		closed_door_sprite_2d.visible = true
		call_deferred("_enable_collision_shape")
		
func _enable_collision_shape():
	collision_shape_2d.disabled = false
	
func _disable_collision_shape():
	collision_shape_2d.disabled = true

func _on_closed_door_area_2d_body_entered(_body):
	if collision_shape_2d.disabled == false:
		call_deferred("_disable_collision_shape")
		Logs._add_log("Le verrou est fermé.")
		await get_tree().create_timer(2.0).timeout
		Logs._add_log("Il semblerait que\ncette porte ne puisse\npas être ouverte en l'état.")
		await get_tree().create_timer(1.0).timeout
		animation_player.play("fade_out")
		EntitiesState.player_parent_node.add_child(preload("res://Objects/Figure/Figure.tscn").instantiate())
		EntitiesState.player_parent_node.add_child(preload("res://Objects/Figure/Figure.tscn").instantiate())
	
