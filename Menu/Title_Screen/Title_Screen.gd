extends CanvasLayer
############### Bouton Standards ##################
@onready var new_game_button : Button = $Standard_Button_VBox/New_Game_Button
@onready var continue_button : Button = $Standard_Button_VBox/Continue_Button
@onready var settings_button : Button = $Standard_Button_VBox/Settings_Button
@onready var quit_button : Button = $Standard_Button_VBox/Quit_Button
############### TITLE BUTTON ##################
@onready var d_button : Button = $Title_HBox/Donjon_HBox/D_Button
@onready var o_button : Button = $Title_HBox/Donjon_HBox/O_Button
@onready var e_button : Button = $Title_HBox/Finale_HBox/E_Button
############### MENU CONFIRMATION ##################
@onready var confirmation_menu_node : Node2D = $Confirmation_Menu_Node
############### ANIMATION PLAYER ##################
@onready var animation_player : AnimationPlayer = $AnimationPlayer
############### SCENES ##################
var transition_scene = preload("res://Transition/Fade_1.tscn")
var option_scene = preload("res://Menu/Options_Screen/Options_Screen.tscn")
var cursor_scene = preload("res://Menu/Cursor/Title_Screen_Cursor.tscn")
var letter_o_scene = preload("res://Menu/Title_Screen/Title_Screen_Effect/Letter_O_Effect.tscn")
############### Variables ##################
var new_game_button_position = Vector2(0,0)
var continue_button_position = Vector2(0,0)
var settings_button_position = Vector2(0,0)
var quit_button_position = Vector2(0,0)
var o_button_position = Vector2(0,0)
var transition_instance = null
var cursor_instance = null
var letter_o_instance = null
var transition_scene_animation_player: AnimationPlayer = null
var letter_o_scene_animation_player: AnimationPlayer = null
var button_tween : Tween

func _ready():
	transition_instance = _add_scene_instance(transition_scene)
	transition_scene_animation_player = transition_instance.get_node("AnimationPlayer")
	_open_scene()
	cursor_instance = _add_scene_instance(cursor_scene)
	letter_o_instance = _add_scene_instance(letter_o_scene)
	letter_o_scene_animation_player = letter_o_instance.get_node("AnimationPlayer")
	new_game_button_position = new_game_button.position
	continue_button_position = continue_button.position
	settings_button_position = settings_button.position
	quit_button_position = quit_button.position
	o_button_position = o_button.position
##################### SCENE #####################
func _add_scene_instance(scene: PackedScene) -> Node:
	var instance = scene.instantiate()
	add_child(instance)
	return instance
func _add_scene_to_root(scene: PackedScene) -> Node:
	var Root = get_tree().root
	var Root_instance = scene.instantiate()
	Root.add_child(Root_instance)
	return Root_instance
func _open_scene():
	transition_scene_animation_player.play("fade_in")
func _close_scene():
	transition_scene_animation_player.play("fade_out")
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
	await get_tree().create_timer(0.2).timeout
	cursor_instance.position = button_position + Vector2(-100,0)
	cursor_instance.visible = false #Mettre sur true si on veut faire fonctionner le curseur
func cursor_deselect(button_position: Vector2):
	await get_tree().create_timer(0.2).timeout
	cursor_instance.position = button_position + Vector2(-70,0)
	cursor_instance.visible = false
##################### BUTTON PRESSED #####################
func _on_settings_button_pressed():
	Signals.title_screen_to_options.emit() #Vers Root
	_close_scene()
	queue_free()
func _on_quit_button_pressed():
	confirmation_menu_node.visible = true
func _on_confirmation_no_button_pressed():
	confirmation_menu_node.visible = false
func _on_confirmation_yes_button_pressed():
	get_tree().quit()
##################### TITLE BUTTON PRESSED #####################
func _on_d_button_pressed():
	d_button.disabled = true
	animation_player.play("Title_D_Effect_On")
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Title_D_Effect_On":
		d_button.disabled = false
func _on_e_button_pressed():
	button_tween = self.create_tween()
	button_tween.stop()
	button_tween.tween_property(e_button, "position", e_button.position + Vector2(64,0), 0.1).set_trans(Tween.TRANS_LINEAR)
	button_tween.play()
func _on_o_button_pressed(): #refaire la fonction pour inclure les autres O
	print("title screen o button position = " + str(o_button.position))
	print("title screen hbox position = " + str($Title_HBox.position))
	move_child(letter_o_instance,2) #Sinon le O ne s'assombrit pas en quittant
	letter_o_instance.position = o_button.position + $Title_HBox.position + Vector2(4,0)#position du premier O
	letter_o_instance.visible = true 
	letter_o_scene_animation_player.play("Letter_O_Effect")
