extends RigidBody2D

@export var chest_id : String = "" # Identifiant unique pour chaque coffre, à définir dans l'éditeur
@export var chest_item : String = "" # Nom de l'objet contenu dans le coffre
@onready var unlocked_chest_sprite : Sprite2D = $Unlocked_Chest_Sprite

func _ready():
	if GameState.chest_is_open(chest_id): #check l'état du coffre à chaque fois que l'objet est instancié
		unlocked_chest_sprite.visible = true
	else:
		unlocked_chest_sprite.visible = false

func _on_interaction_area_body_entered(_body): #ouvre le coffre et change à l'état adéquat
	if !GameState.chest_is_open(chest_id): #vérifie si le coffre n'a pas déjà été ouvert
		unlocked_chest_sprite.visible = true
		GameState.open_chest(chest_id)
		if chest_item != "": #on ajoute l'objet s'il n'est pas vide
			Inventory._add_item(chest_item)
			Logs._log_item("Open_Chest",chest_item)
