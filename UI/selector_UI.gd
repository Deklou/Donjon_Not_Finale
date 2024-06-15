extends Node2D

func _ready():
	EntitiesState.show_selector_UI.connect(show_selector)
	EntitiesState.change_selector_position_UI.connect(change_selector_position)
	EntitiesState.hide_selector_UI.connect(hide_selector)

func show_selector(enemy_position: Vector2):
	$sprite_selector.global_position = enemy_position
	EntitiesState.selector_position = enemy_position
	$sprite_selector.visible = true
	
func change_selector_position(enemy_position : Vector2):
	$sprite_selector.global_position = enemy_position
	EntitiesState.selector_position = enemy_position

func hide_selector():
	$sprite_selector.visible = false
	EntitiesState.selector_position = Vector2(0,0) #On vient reset la position du selecteur par sécurité
