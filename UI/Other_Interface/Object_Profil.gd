extends Control
@onready var object_profil = $"." #pour avoir un contrôle sur la visibilité de cette partie de l'interface
@onready var UI_object_Name : RichTextLabel = $VBoxContainer/Name
var interface_id : String #identifiant de l'interface, le même que l'object dont il est associé
var interface_name : String #nom de l'interface, le même que l'object dont il est associé
##################### READY #####################
func _ready():
	interface_id = EntitiesState.enemy_id
	interface_name = GameState.object_name
	UI_object_Name.text = interface_name
	EntitiesState.delete_other_UI.connect(_delete_interface)
	EntitiesState.show_other_UI.connect(show_enemy_UI)
	EntitiesState.hide_other_UI.connect(hide_enemy_UI)
##################### SUPPRESSION #####################
func _delete_interface():
	if interface_id == EntitiesState.enemy_id:
		$"..".queue_free()
##################### AFFICHAGE #####################
func show_enemy_UI():
	if interface_id == EntitiesState.selected_id: 
		object_profil.visible = true
	else:
		object_profil.visible = false
func hide_enemy_UI(): #on appelle cette fonction dans le script de l'ennmi s'il est mort
	if interface_id == EntitiesState.selected_id:
		object_profil.visible = false
