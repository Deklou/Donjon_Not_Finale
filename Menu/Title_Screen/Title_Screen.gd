extends CanvasLayer
############### Bouton Standards ##################
@onready var new_game_button : Button = $Standard_Button_VBox/New_Game_Button
@onready var continue_button : Button = $Standard_Button_VBox/Continue_Button
@onready var settings_button : Button = $Standard_Button_VBox/Settings_Button
@onready var quit_button : Button = $Standard_Button_VBox/Quit_Button
############### TITLE BUTTON ##################
@onready var o_button : Button = $Title_HBox/Donjon_HBox/O_Button
@onready var e_button : Button = $Title_HBox/Finale_HBox/E_Button
############### MENU CONFIRMATION ##################
@onready var confirmation_menu_node : Node2D = $Confirmation_Menu_Node
############### ANIMATION PLAYER ##################
@onready var animation_player : AnimationPlayer = $AnimationPlayer
############### Variables ##################
var new_game_button_position = Vector2(0,0)
var continue_button_position = Vector2(0,0)
var settings_button_position = Vector2(0,0)
var quit_button_position = Vector2(0,0)
var o_button_position = Vector2(0,0)
var transition_scene_instance = null
var transition_scene_animation_player = null
var cursor_scene_instance = null
var button_tween : Tween
var letter_o_scene_instance = null
var letter_o_scene_animation_player = null

func _ready():
	new_game_button_position = new_game_button.position
	continue_button_position = continue_button.position
	settings_button_position = settings_button.position
	quit_button_position = quit_button.position
	o_button_position = o_button.position
	transition_scene_instance = preload("res://Transition/Fade_1.tscn").instantiate()
	cursor_scene_instance = preload("res://Menu/Cursor/Title_Screen_Cursor.tscn").instantiate()
	add_child(cursor_scene_instance)
	cursor_scene_instance.visible = false
	add_child(transition_scene_instance)
	transition_scene_animation_player = transition_scene_instance.get_node("AnimationPlayer")
	transition_scene_animation_player.play("fade_in")
##################### BOUTON SELECT #####################
func _on_new_game_button_mouse_entered():
	tween_select(new_game_button,new_game_button_position, "select")
	cursor_select(new_game_button_position)
func _on_new_game_button_mouse_exited():
	tween_select(new_game_button,new_game_button_position, "deselect")
	cursor_deselect(new_game_button_position)
func _on_continue_button_mouse_entered():
	tween_select(continue_button,continue_button_position, "select")
	cursor_select(continue_button_position)
func _on_continue_button_mouse_exited():
	tween_select(continue_button,continue_button_position, "deselect")
	cursor_deselect(continue_button_position)
func _on_settings_button_mouse_entered():
	tween_select(settings_button,settings_button_position, "select")
	cursor_select(settings_button_position)
func _on_settings_button_mouse_exited():
	tween_select(settings_button,settings_button_position, "deselect")
	cursor_deselect(settings_button_position)
func _on_quit_button_mouse_entered():
	tween_select(quit_button,quit_button_position, "select")
	cursor_select(quit_button_position)
func _on_quit_button_mouse_exited():
	tween_select(quit_button,quit_button_position, "deselect")
	cursor_deselect(quit_button_position)
##################### TWEEN #####################
func tween_select(button: Button, button_position: Vector2,mode: String): #besoin de créer le tween et le stopper au même endroit où il est utilisé, d'où la fonction
	if mode == "select":
		button_position += Vector2(-32,0)
	button_tween = self.create_tween()
	button_tween.stop()
	button_tween.tween_property(button, "position", button_position, 0.1).set_trans(Tween.TRANS_LINEAR)
	button_tween.play()
##################### CURSOR #####################
func cursor_select(button_position: Vector2):
	get_tree().create_timer(0.2)
	cursor_scene_instance.position = button_position + Vector2(-100,0)
	cursor_scene_instance.visible = false
func cursor_deselect(button_position: Vector2):
	get_tree().create_timer(0.2)
	cursor_scene_instance.position = button_position + Vector2(-70,0)
	cursor_scene_instance.visible = false
##################### BUTTON PRESSED #####################
func _on_quit_button_pressed():
	confirmation_menu_node.visible = true
func _on_confirmation_no_button_pressed():
	confirmation_menu_node.visible = false
func _on_confirmation_yes_button_pressed():
	get_tree().quit()
##################### TITLE BUTTON PRESSED #####################
func _on_d_button_pressed():
	animation_player.play("Title_D_Effect_On")
func _on_e_button_pressed():
	button_tween = self.create_tween()
	button_tween.stop()
	button_tween.tween_property(e_button, "position", e_button.position + Vector2(64,0), 0.1).set_trans(Tween.TRANS_LINEAR)
	button_tween.play()
func _on_o_button_pressed():
	letter_o_scene_instance = preload("res://Menu/Title_Screen/Title_Screen_Effect/Letter_O_Effect.tscn").instantiate()
	letter_o_scene_animation_player = letter_o_scene_instance.get_node("AnimationPlayer")
	add_child(letter_o_scene_instance)
	move_child(letter_o_scene_instance,2) #Sinon le O ne s'assombrit pas en quittant 
	letter_o_scene_instance.position = Vector2(183,65)
	letter_o_scene_animation_player.play("Letter_O_Effect")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Title_D_Effect_On":
		print("title screen caca")
		#emit signal
		#et quand le signal est reçu delock le bouton
