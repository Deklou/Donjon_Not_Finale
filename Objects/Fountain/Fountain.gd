extends Node2D
@export var fountain_id : String  #Identifiant unique pour chaque fontaine
@export var fountain_name : String = "" # Nom de l'objet contenu dans le coffre
@export var fountain_point : int #Identifiant unique pour chaque fontaine
@export var fountain_sprite_path : String
@onready var fountain_sprite : Sprite2D = $Fountain_Sprite2D
@onready var water_sprite : Sprite2D = $Water_Sprite2D
##################### READY  #####################
func _ready():
	GameState.fountain_has_been_used.connect(_on_fountain_water_sprite_disabled)
	GameState.fountain_attributes[fountain_id] = fountain_point
	if fountain_id in GameState.fountain_states:
		water_sprite.visible = false
	if fountain_sprite_path != "":
		var texture = load(fountain_sprite_path)
		if texture:
			fountain_sprite.texture = texture
##################### INTERACTION JOUEUR #####################
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
##################### FONTAINE ASSECHEE #####################		
func _on_fountain_water_sprite_disabled(id : String):
	if id == fountain_id:
		water_sprite.visible = false
		Logs._add_log("La source s'est asséchée.")
##################### PRESENCE ECRAN #####################
func _on_visible_on_screen_notifier_2d_screen_entered(): #Crée une interface liée à l'ennemi
	EntitiesState.enemy_id = fountain_id #l'id dont on se sert pour lier l'ennemi à son interface
	GameState.object_name = fountain_name #Nom à afficher sur l'interface
	EntitiesState.instanciate_other_UI.emit("object") #Vers user_interface
func _on_visible_on_screen_notifier_2d_screen_exited(): #Cache l'interface liée à l'ennemi
	EntitiesState.enemy_id = fountain_id #l'id dont on se sert pour l'interface à supprimer
	EntitiesState.delete_other_UI.emit() #Vers enemy_profil_ui
##################### INTERFACE ET SELECTEUR #####################
func _on_mouse_area_2d_mouse_entered():
	EntitiesState.selected_id = fountain_id
func _on_mouse_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true:
		if EntitiesState.selector_position == $".".position + Vector2(64,0):
			EntitiesState.enemy_id = fountain_id #Besoin de lier les deux pour cacher le selecteur
			EntitiesState.enemy_is_deselected()
		else:
			EntitiesState.enemy_selected($".".position + Vector2(64,0), fountain_id) #on aeppelle la fonction pour rendre visible l'interface ennemi #on remet l'état à faux pour qu'il ne soit appelé qu'une fois
