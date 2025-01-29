extends CanvasLayer

############### NODES ##################
@onready var back_button : Button = $Back_Button
@onready var animation_player : AnimationPlayer = $AnimationPlayer
############### SCENES ##################
var transition_scene = preload("res://Transition/Fade_1.tscn")
############### Variables ##################
var transition_scene_animation_player: AnimationPlayer = null
var transition_instance = null

##################### READY #####################
func _ready():
	transition_instance = _add_scene_instance(transition_scene)
	transition_scene_animation_player = transition_instance.get_node("AnimationPlayer")
	_open_scene()
##################### ZQSD ET BARRE ESPACE #####################
func _input(event):
	handle_key_input(event)	
func handle_key_input(event):
	if event.is_action_pressed("up"):
		animation_player.play("z_pressed")
	elif event.is_action_released("up"):
		animation_player.play("z_released")
	if event.is_action_pressed("down"):
		animation_player.play("s_pressed")
	elif event.is_action_released("down"):
		animation_player.play("s_released")
	if event.is_action_pressed("left"):
		animation_player.play("q_pressed")
	elif event.is_action_released("left"):
		animation_player.play("q_released")
	if event.is_action_pressed("right"):
		animation_player.play("d_pressed")
	elif event.is_action_released("right"):
		animation_player.play("d_released")
	if event.is_action_pressed("wait"):
		animation_player.play("space_bar_pressed")
	elif event.is_action_released("wait"):
		animation_player.play("space_bar_released")
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
##################### BUTTON PRESSED #####################
func _on_back_button_pressed():
	Signals.options_back.emit() #Vers Root
	_close_scene()
	queue_free()
