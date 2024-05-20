extends Node2D

@onready var figure_animation_player : AnimationPlayer = $ColorRect_Animation/AnimationPlayer_Fade
@export var distance = 64 #taille d'une case
var currPos
var animation_is_triggered : bool = false

func _ready():
	currPos = $".".position
	currPos.x = round(currPos.x / distance) * distance - 32
	currPos.y = round(currPos.y / distance) * distance - 32
	position = currPos

func _on_trigger_area_2d_body_entered(body):
	if body is Node2D and animation_is_triggered == false:
		animation_is_triggered = true
		figure_animation_player.play("fade_in")
		await get_tree().create_timer(3.0).timeout
		queue_free()

