extends CanvasLayer

############### NODES ##################
@onready var objectif_text_label : RichTextLabel = $Objectif/Objectif_Text
@onready var information_text_label : RichTextLabel = $Information/Information_Text
@onready var confirm_button : Button = $Confirm_Button
############### SCENES ##################
var transition_scene = preload("res://Transition/Fade_1.tscn")
var thumbs_up_scene = preload("res://Menu/Thumbs_Up/Thumbs_Up.tscn")
############### VARIABLES ##################
var transition_instance = null
var thumbs_up_instance = null
var transition_scene_animation_player: AnimationPlayer = null
var player_has_validated : bool = false
var confirm_button_position = Vector2(0,0)

##################### READY #####################
func _ready():
	transition_instance = _add_scene_instance(transition_scene)
	transition_scene_animation_player = transition_instance.get_node("AnimationPlayer")
	_open_scene()
	
	objectif_text_label.bbcode_text = "[font_size=30]" + "Monter jusqu'au" + "[color=#ffe600]" + " dernier étage " + "[/color]" + "en restant en vie et sortir." + "[/font_size]"
	information_text_label.bbcode_text = "[font_size=30]" + "Vaincre un ennemi augmente votre" + "[color=#ffe600]" + " expérience" + "[/color]" + ". Avec assez d'expérience, vous  pourrez  augmenter  les  différents attributs qui vous définissent.

Vous pourrez également trouver des objets au cours de votre périple pour alléger votre peine." + "[/font_size]"
	confirm_button_position = confirm_button.position
	print("objectif screen " + str(confirm_button_position))
##################### SCENE GESTION #####################
func _add_scene_instance(scene: PackedScene) -> Node:
	var instance = scene.instantiate()
	add_child(instance)
	return instance
##################### ANIMATION #####################
func _open_scene():
	transition_scene_animation_player.play("fade_in")
func _close_scene():
	transition_scene_animation_player.play("fade_out")
##################### BUTTON #####################
func _on_confirm_button_pressed():
	thumbs_up_instance = _add_scene_instance(thumbs_up_scene)
	thumbs_up_instance.position = confirm_button_position + Vector2(310,18)
	_close_scene()
	await get_tree().create_timer(1).timeout
	Signals.to_command_screen.emit() #vers Root
	queue_free()
