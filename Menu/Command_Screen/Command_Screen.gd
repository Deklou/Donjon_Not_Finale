extends Node2D

@onready var command_label : RichTextLabel = $Black_Background_ColorRect/Command_Label
@onready var command_animation_player : AnimationPlayer = $ColorRect_Animation/AnimationPlayer_Fade
@onready var cursor_sprite_2d : Sprite2D = $Black_Background_ColorRect/Mouse_Command/Cursor_Sprite2D
@onready var mouse_sprite_2d : Sprite2D = $Black_Background_ColorRect/Mouse_Command/Mouse_Sprite2D
@onready var cursor_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Mouse_Command_Green/Cursor_Green_Sprite2D
@onready var mouse_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Mouse_Command_Green/Mouse_Green_Sprite2D
@onready var Z_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Letters/Z_Sprite2D
@onready var Q_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Letters/Q_Sprite2D
@onready var S_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Letters/S_Sprite2D
@onready var D_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Letters/D_Sprite2D
@onready var Z_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Letters_Green/Z_Green_Sprite2D
@onready var Q_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Letters_Green/Q_Green_Sprite2D
@onready var S_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Letters_Green/S_Green_Sprite2D
@onready var D_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Letters_Green/D_Green_Sprite2D
@onready var arrow_up_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Arrows/Arrow_Up_Sprite2D
@onready var arrow_left_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Arrows/Arrow_Left_Sprite2D
@onready var arrow_down_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Arrows/Arrow_Down_Sprite2D
@onready var arrow_right_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Arrows/Arrow_Right_Sprite2D
@onready var arrow_up_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Arrows_Green/Arrow_Up_Green_Sprite2D
@onready var arrow_left_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Arrows_Green/Arrow_Left_Green_Sprite2D
@onready var arrow_down_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Arrows_Green/Arrow_Down_Green_Sprite2D
@onready var arrow_right_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Arrows_Green/Arrow_Right_Green_Sprite2D
@onready var space_bar_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command/Keyboard_Other/Space_Bar_Sprite2D
@onready var space_bar_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Keyboard_Command_Green/Keyboard_Other_Green/Space_Bar_Green_Sprite2D
@onready var button_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Button_Sprite_2D
@onready var button_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Button_Green_Sprite_2D
var player_has_moved_mouse : bool = false
var player_has_clicked : bool = false
var player_has_entered_button : bool = false
var player_has_validated : bool = false
var mouse_movement_timeout : Timer
signal to_objectif_screen 

func _ready():
	command_animation_player.play("fade_in")
	command_label.bbcode_text = "[b]" + command_label.text + "[/b]"
	command_label.bbcode_text = "[font_size=40]" + command_label.text + "[/font_size]"
	mouse_movement_timeout = Timer.new()
	mouse_movement_timeout.wait_time = 0.1
	mouse_movement_timeout.one_shot = true
	mouse_movement_timeout.timeout.connect(_on_mouse_movement_timeout)
	add_child(mouse_movement_timeout)
	
func reset_all_sprite():
	var sprite : Array = [cursor_sprite_2d,mouse_sprite_2d,Z_sprite_2d,Q_sprite_2d,S_sprite_2d,D_sprite_2d,arrow_up_sprite_2d,arrow_left_sprite_2d,arrow_down_sprite_2d,arrow_right_sprite_2d,button_sprite_2d]
	var green_sprite : Array = [cursor_green_sprite_2d,mouse_green_sprite_2d,Z_green_sprite_2d,Q_green_sprite_2d,S_green_sprite_2d,D_green_sprite_2d,arrow_up_green_sprite_2d,arrow_left_green_sprite_2d,arrow_down_green_sprite_2d,arrow_right_green_sprite_2d,button_green_sprite_2d]
	for node in sprite:
		node.visible = true
	for node in green_sprite:
		node.visible = false
		
func _input(event):
	if player_has_entered_button == false:
		if event is InputEventMouseMotion:
			mouse_sprite_2d.visible = false
			mouse_green_sprite_2d.visible  = true
			mouse_movement_timeout.start()
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					cursor_sprite_2d.visible = false
					cursor_green_sprite_2d.visible = true
					player_has_clicked = true
				else:
					cursor_sprite_2d.visible = true
					cursor_green_sprite_2d.visible = false
					player_has_clicked = false
		else:
			handle_key_input(event)

func handle_key_input(event):
	if event.is_action_pressed("up"):
		Z_sprite_2d.visible = false
		Z_green_sprite_2d.visible = true
	elif event.is_action_released("up"):
		Z_sprite_2d.visible = true
		Z_green_sprite_2d.visible = false
	arrow_up_sprite_2d.visible = Z_sprite_2d.visible
	arrow_up_green_sprite_2d.visible = Z_green_sprite_2d.visible
	if event.is_action_pressed("down"):
		S_sprite_2d.visible = false
		S_green_sprite_2d.visible = true
	elif event.is_action_released("down"):
		S_sprite_2d.visible = true
		S_green_sprite_2d.visible = false
	arrow_down_sprite_2d.visible = S_sprite_2d.visible
	arrow_down_green_sprite_2d.visible = S_green_sprite_2d.visible
	if event.is_action_pressed("left"):
		Q_sprite_2d.visible = false
		Q_green_sprite_2d.visible = true
	elif event.is_action_released("left"):
		Q_sprite_2d.visible = true
		Q_green_sprite_2d.visible = false
	arrow_left_sprite_2d.visible = Q_sprite_2d.visible
	arrow_left_green_sprite_2d.visible = Q_green_sprite_2d.visible
	if event.is_action_pressed("right"):
		D_sprite_2d.visible = false
		D_green_sprite_2d.visible = true
	elif event.is_action_released("right"):
		D_sprite_2d.visible = true
		D_green_sprite_2d.visible = false
	arrow_right_sprite_2d.visible = D_sprite_2d.visible
	arrow_right_green_sprite_2d.visible = D_green_sprite_2d.visible
	if event.is_action_pressed("wait"):
		space_bar_sprite_2d.visible = false
		space_bar_green_sprite_2d.visible = true
	elif event.is_action_released("wait"):
		space_bar_sprite_2d.visible = true
		space_bar_green_sprite_2d.visible = false
			
func _on_mouse_movement_timeout():
	mouse_sprite_2d.visible = true
	mouse_green_sprite_2d.visible = false
				
func _process(_delta):
	cursor_sprite_2d.visible = not player_has_clicked
	cursor_green_sprite_2d.visible = player_has_clicked
	button_green_sprite_2d.visible = not button_sprite_2d.visible
	player_has_entered_button = button_green_sprite_2d.visible
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true and button_sprite_2d.visible == false and player_has_validated == false:
		reset_all_sprite()
		player_has_validated = true
		var thumbs_up_scene = preload("res://Menu/Thumbs_Up/Thumbs_Up.tscn").instantiate()
		add_child.call_deferred(thumbs_up_scene)
		thumbs_up_scene.position = Vector2(832,624)
		button_sprite_2d.visible = true
		await get_tree().create_timer(0.1).timeout
		button_sprite_2d.visible = false
		await get_tree().create_timer(0.5).timeout
		command_animation_player.play("fade_out")
		await get_tree().create_timer(0.7).timeout
		to_objectif_screen.emit() #Vers Root
		queue_free()

func _on_area_2d_mouse_entered():
	reset_all_sprite()
	button_sprite_2d.visible = false
	button_green_sprite_2d.visible = not button_sprite_2d.visible

func _on_area_2d_mouse_exited():
	button_sprite_2d.visible = true
