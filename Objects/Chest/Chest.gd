extends RigidBody2D

@export var chest_id : String = "" # Identifiant unique pour chaque coffre, à définir dans l'éditeur
@export var chest_name : String = "" # Nom de l'objet contenu dans le coffre
@export var chest_item : String = "" # Nom de l'objet contenu dans le coffre
@onready var unlocked_chest_sprite : Sprite2D = $Unlocked_Chest_Sprite
@export var distance = 64 #taille d'une case
var currPos
##################### READY #####################
func _ready():
	if GameState.chest_is_open(chest_id): #check l'état du coffre à chaque fois que l'objet est instancié
		unlocked_chest_sprite.visible = true
	else:
		unlocked_chest_sprite.visible = false
	currPos = $".".position
	currPos.x = round(currPos.x / distance) * distance - 32
	currPos.y = round(currPos.y / distance) * distance - 32
	position = currPos
##################### INTERACTION JOUEUR #####################
func _on_interaction_area_body_entered(_body): #ouvre le coffre et change à l'état adéquat
	if !GameState.chest_is_open(chest_id): #vérifie si le coffre n'a pas déjà été ouvert
		unlocked_chest_sprite.visible = true
		GameState.open_chest(chest_id)
		if chest_item != "": #on ajoute l'objet s'il n'est pas vide
			Inventory._add_item(chest_item)
			Logs._log_item("Open_Chest",chest_item)
##################### PRESENCE ECRAN #####################
func _on_visible_on_screen_notifier_2d_screen_entered(): #Crée une interface liée à l'ennemi
	EntitiesState.enemy_id = chest_id #l'id dont on se sert pour lier l'ennemi à son interface
	GameState.object_name = chest_name #Nom à afficher sur l'interface
	EntitiesState.instanciate_other_UI.emit("object") #Vers user_interface
func _on_visible_on_screen_notifier_2d_screen_exited(): #Cache l'interface liée à l'ennemi
	EntitiesState.enemy_id = chest_id #l'id dont on se sert pour l'interface à supprimer
	EntitiesState.delete_other_UI.emit() #Vers enemy_profil_ui
##################### INTERFACE ET SELECTEUR #####################
func _on_mouse_area_2d_mouse_entered():
	EntitiesState.selected_id = chest_id
func _on_mouse_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true:
		if EntitiesState.selector_position == $".".position:
			EntitiesState.enemy_id = chest_id #Besoin de lier les deux pour cacher le selecteur
			EntitiesState.enemy_is_deselected()
		else:
			EntitiesState.enemy_selected($".".position, chest_id) #on aeppelle la fonction pour rendre visible l'interface ennemi #on remet l'état à faux pour qu'il ne soit appelé qu'une fois
