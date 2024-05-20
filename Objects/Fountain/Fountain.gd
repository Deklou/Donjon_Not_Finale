extends Node2D
@export var fountain_id : int #Identifiant unique pour chaque fontaine
@export var fountain_point : int #Identifiant unique pour chaque fontaine
@export var fountain_sprite_path : String
@onready var fountain_sprite : Sprite2D = $Fountain_Sprite2D
@onready var water_sprite : Sprite2D = $Water_Sprite2D

func _ready():
	GameState.fountain_has_been_used.connect(_on_fountain_water_sprite_disabled)
	GameState.fountain_attributes[fountain_id] = fountain_point
	if fountain_id in GameState.fountain_states:
		water_sprite.visible = false
	if fountain_sprite_path != "":
		var texture = load(fountain_sprite_path)
		if texture:
			fountain_sprite.texture = texture

func _on_fountain_area_2d_body_entered(_body):
	if fountain_id not in GameState.fountain_states:
		GameState.fountain_id = fountain_id
		GameState.fountain_is_currently_used = true
		XpSystem.UI_stat_special_button.emit() #vers player_profil_UI
		Logs._add_log("Cette source sacrée\nvous permet de choisir\nentre deux types d'effets.")
		await get_tree().create_timer(2.2).timeout
		Logs._add_log("Cependant, vous ne\npouvez en choisir qu'un\nseul.")

func _on_fountain_area_2d_body_exited(_body):
	if fountain_id not in GameState.fountain_states:
		GameState.fountain_is_currently_used = false
		XpSystem.UI_stat_special_button.emit() #vers player_profil_UI
		
func _on_fountain_water_sprite_disabled(id : int):
	if id == fountain_id:
		water_sprite.visible = false
		Logs._add_log("La source s'est asséchée.")
