extends CanvasLayer

############### NODES ##################
@onready var back_button : Button = $Back_Button
@onready var animation_player : AnimationPlayer = $AnimationPlayer
############### SCENES ##################
var transition_scene = preload("res://Transition/Fade_1.tscn")
############### VARIABLES ##################
var transition_scene_animation_player: AnimationPlayer = null
var transition_instance = null
var back_button_position = Vector2(0,0)
var mouse_movement_timeout : Timer
var button_tween : Tween
var space_bar_pressed_event : bool = false

##################### READY #####################
func _ready():
	transition_instance = _add_scene_instance(transition_scene)
	transition_scene_animation_player = transition_instance.get_node("AnimationPlayer")
	_open_scene()
	back_button_position = back_button.position
	
	mouse_movement_timeout = Timer.new()
	mouse_movement_timeout.wait_time = 0.1
	mouse_movement_timeout.one_shot = true
	mouse_movement_timeout.timeout.connect(_on_mouse_movement_timeout)
	add_child(mouse_movement_timeout)
##################### ZQSD ET BARRE ESPACE #####################
func _input(event):
	if event is InputEventMouseMotion:
			animation_player.play("mouse_moved")
			mouse_movement_timeout.start()
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					animation_player.play("click_pressed")
				else:
					animation_player.play("click_released")
	else:
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
func _on_mouse_movement_timeout():
	animation_player.play("mouse_still")
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
##################### BACK BUTTON #####################
func _on_back_button_mouse_entered():
	tween_select(back_button,back_button_position, "select")
func _on_back_button_mouse_exited():
	tween_select(back_button,back_button_position, "deselect")
func _on_back_button_pressed():
	Signals.options_back.emit() #Vers Root
	_close_scene()
	queue_free()
##################### TWEEN #####################
func tween_select(button: Button, button_position: Vector2,mode: String): #besoin de créer le tween et le stopper au même endroit où il est utilisé, d'où la fonction
	if mode == "select":
		button_position += Vector2(-32,0)
	button_tween = self.create_tween()
	button_tween.stop()
	button_tween.tween_property(button, "position", button_position, 0.1).set_trans(Tween.TRANS_LINEAR)
	button_tween.play()
