extends Node2D
@onready var selector_sprite_2d : Sprite2D = $sprite_selector

func _ready():
	EntitiesState.show_selector_UI.connect(show_selector)
	EntitiesState.change_selector_position_UI.connect(change_selector_position)
	EntitiesState.hide_selector_UI.connect(hide_selector)
	EntitiesState.delete_other_UI.connect(hide_selector)

func show_selector(enemy_position: Vector2):
	selector_sprite_2d.global_position = enemy_position
	EntitiesState.selector_position = enemy_position
	selector_sprite_2d.visible = true
	
func change_selector_position(enemy_position : Vector2):
	selector_sprite_2d.global_position = enemy_position
	EntitiesState.selector_position = enemy_position

func hide_selector():
	if EntitiesState.enemy_id == EntitiesState.selected_id: #si l'ennemi qui disparait est l'ennemi séléctionné
		selector_sprite_2d.visible = false
		EntitiesState.selector_position = Vector2(0,0) #On vient reset la position du selecteur par sécurité
