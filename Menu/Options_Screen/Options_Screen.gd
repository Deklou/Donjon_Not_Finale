extends CanvasLayer

@onready var back_button : Button = $Back_Button
############### SCENES ##################
var transition_scene = preload("res://Transition/Fade_1.tscn")
var title_screen_scene = preload("res://Menu/Title_Screen/title_screen.tscn")
############### Variables ##################
var transition_scene_animation_player: AnimationPlayer = null
var transition_instance = null

func _ready():
	transition_instance = _add_scene_instance(transition_scene)
	transition_scene_animation_player = transition_instance.get_node("AnimationPlayer")
	_open_scene()
func _add_scene_instance(scene: PackedScene) -> Node:
	var instance = scene.instantiate()
	add_child(instance)
	return instance
func _open_scene():
	transition_scene_animation_player.play("fade_in")
func _close_scene():
	transition_scene_animation_player.play("fade_out")
##################### BUTTON PRESSED #####################
func _on_back_button_pressed():
	Signals.options_back.emit() #Vers Root
	_close_scene()
	queue_free()
