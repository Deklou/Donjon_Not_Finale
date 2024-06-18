extends Node2D
var interface_id : String #identifiant de l'interface, le même que l'ennemi dont elel est associée
##################### READY #####################
func _ready():
	interface_id = EntitiesState.enemy_id
	EntitiesState.delete_other_UI.connect(_delete_interface)
##################### SUPPRESSION #####################
func _delete_interface():
	if interface_id == EntitiesState.enemy_id:
		queue_free()
