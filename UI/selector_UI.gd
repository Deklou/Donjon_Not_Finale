extends Node2D

func _ready():
	EntitiesState.show_selector_UI.connect(show_selector)
	EntitiesState.hide_selector_UI.connect(hide_selector)


func show_selector(position_enemy: Vector2):
	$sprite_selector.global_position = position_enemy
	$sprite_selector.visible = true

func hide_selector():
	$sprite_selector.visible = false
