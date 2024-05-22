extends CanvasLayer

@onready var result_vbox_container : VBoxContainer = $Black_Background_ColorRect/Result_VBoxContainer
@onready var variable_vbox_container : VBoxContainer = $Black_Background_ColorRect/Variable_VBoxContainer
@onready var stage_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Stage_Label
@onready var weapon_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Weapon_Label
@onready var enemy_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Enemy_Label
@onready var secret_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Secret_Label
@onready var time_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Time_Label
@onready var death_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Death_Label
@onready var level_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Level_Label
@onready var stats_label : RichTextLabel = $Black_Background_ColorRect/Category_VBoxContainer/Stats_Label
@onready var stage_result_label : RichTextLabel = $Black_Background_ColorRect/Result_VBoxContainer/Stage_Result_Label
@onready var weapon_result_label : RichTextLabel = $Black_Background_ColorRect/Result_VBoxContainer/Weapon_Result_Label
@onready var enemy_result_label : RichTextLabel = $Black_Background_ColorRect/Result_VBoxContainer/Enemy_Result_Label
@onready var secret_result_label : RichTextLabel = $Black_Background_ColorRect/Result_VBoxContainer/Secret_Result_Label
@onready var time_result_label : RichTextLabel = $Black_Background_ColorRect/Result_VBoxContainer/Time_Result_Label
@onready var death_result_label : RichTextLabel = $Black_Background_ColorRect/Result_VBoxContainer/Death_Result_Label
@onready var variable_stage_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Stage_Result_Label
@onready var variable_weapon_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Weapon_Result_Label
@onready var variable_enemy_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Enemy_Result_Label
@onready var variable_secret_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Secret_Result_Label
@onready var variable_time_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Time_Result_Label
@onready var variable_death_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Death_Result_Label
@onready var variable_level_result_label : RichTextLabel = $Black_Background_ColorRect/Variable_VBoxContainer/Variable_Level_Result_Label
@onready var command_animation_player : AnimationPlayer = $ColorRect_Animation/AnimationPlayer_Fade
@onready var button_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Button_Sprite_2D
@onready var button_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Button_Green_Sprite_2D
@onready var restart_button_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Restart_Button_Sprite_2D
@onready var restart_button_green_sprite_2d : Sprite2D = $Black_Background_ColorRect/Button/Restart_Button_Green_Sprite_2D
@onready var special_sprite_2d : Sprite2D = $Black_Background_ColorRect/Special_Sprite2D
var chosen_button_type : Sprite2D
var chosen_button_green_type : Sprite2D
var not_chosen_button_type : Sprite2D
var not_chosen_button_green_type : Sprite2D
var player_has_validated : bool = false
signal to_intro_level

func _ready():
	command_animation_player.play("fade_in")
	stage_label.bbcode_text = "[b][font_size=30]" + stage_label.text + "[/font_size][/b]"
	weapon_label.bbcode_text = "[b][font_size=30]" + weapon_label.text + "[/font_size][/b]"
	enemy_label.bbcode_text = "[b][font_size=30]" + enemy_label.text + "[/font_size][/b]"
	secret_label.bbcode_text = "[b][font_size=30]" + secret_label.text + "[/font_size][/b]"
	time_label.bbcode_text = "[b][font_size=30]" + time_label.text + "[/font_size][/b]"
	level_label.bbcode_text = "[b][font_size=30]" + level_label.text + "[/font_size][/b]"
	if GameData.player_death_count == 0:
		death_label.bbcode_text = "[b][font_size=30]" + "Faites de votre mieux !" + "[/font_size][/b]"
	elif GameData.player_death_count == 1:
		death_label.bbcode_text = "[b][font_size=30]" + "Faites de votre mieux un peu mieux !" + "[/font_size][/b]"
	elif GameData.player_death_count == 2:
		death_label.bbcode_text = "[b][font_size=30]" + "Même les plus grands héros ont des jours difficiles.." + "[/font_size][/b]"
	elif GameData.player_death_count == 3:
		death_label.bbcode_text = "[b][font_size=30]" + "La troisième c'est la bonne." + "[/font_size][/b]"
	elif GameData.player_death_count == 4:
		death_label.bbcode_text = "[b][font_size=30]" + "Eh, chaque échec est une opportunité de s'améliorer !" + "[/font_size][/b]"
	elif GameData.player_death_count == 5:
		death_label.bbcode_text = "[b][font_size=30]" + "ça a l'air compliqué..." + "[/font_size][/b]"
	else:
		death_label.bbcode_text = "[b][font_size=30]" + "..." + "[/font_size][/b]"
	for label in result_vbox_container.get_children():
		label.bbcode_text = "[b][font_size=30]" + label.text + "[/font_size][/b]"
	if GameState.ending_triggered == true:
		death_label.bbcode_text = "[b][font_size=30]" + "Nombre de mort" + "[/font_size][/b]"
		variable_stage_result_label.text = "   1"
		variable_weapon_result_label.text = "   " + str(GameData.legendary_weapon_acquired)
		variable_enemy_result_label.text = "   " + str(GameData.enemy_defeated)
		variable_secret_result_label.text = "   0"
		variable_time_result_label.text = " " + str(int(int(GameData.timer) / 3600.0)) + "h " + str((int(GameData.timer) % 3600) / 60) + "min " + str(int(GameData.timer) % 60) + "s"
		variable_death_result_label.text = "   " + str(GameData.player_death_count)
		level_label.visible = true
		stats_label.visible = true
		variable_level_result_label.text = "[b][font_size=30]" + "   " + str(GameData.player_LVL) + "[/font_size][/b]"
		stats_label.text = "[font_size=30]" + "HP: " + str(GameData.player_MAX_HP) + "  FRC: " + str(GameData.player_STR) + "  DEX: " + str(GameData.player_DEX) + "  DEF: " + str(GameData.player_DEF) + "  MVT: " + str(GameData.default_player_MAX_movement_point) + "  ACT: " + str(GameData.player_MAX_action_point) +"[/font_size]"
		if GameData.secret_triggered == true:
			variable_secret_result_label.text = "   1"
		if GameState.kojiro_was_obtained == true:
			special_sprite_2d.visible = true
		for label in variable_vbox_container.get_children():
			label.bbcode_text = "[b][font_size=30]" + label.text + "[/font_size][/b]"

func _on_area_2d_mouse_entered():
	if GameState.ending_triggered == true:
		restart_button_sprite_2d.visible = false
		restart_button_green_sprite_2d.visible = not restart_button_sprite_2d.visible
	else:
		button_sprite_2d.visible = false
		button_green_sprite_2d.visible = not button_sprite_2d.visible

func _on_area_2d_mouse_exited():
	if GameState.ending_triggered == true:
		restart_button_sprite_2d.visible = true
	else:
		button_sprite_2d.visible = true
	
func _process(_delta):
	if GameState.ending_triggered == true:
		chosen_button_type = restart_button_sprite_2d
		chosen_button_green_type = restart_button_green_sprite_2d
		not_chosen_button_type = button_sprite_2d
		not_chosen_button_green_type = button_green_sprite_2d	
	else:
		chosen_button_type = button_sprite_2d
		chosen_button_green_type = button_green_sprite_2d
		not_chosen_button_type = restart_button_sprite_2d
		not_chosen_button_green_type = restart_button_green_sprite_2d
	not_chosen_button_type.visible = false
	not_chosen_button_green_type.visible = not_chosen_button_type.visible
	chosen_button_green_type.visible = not chosen_button_type.visible
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true and chosen_button_type.visible == false and player_has_validated == false:
		player_has_validated = true
		var thumbs_up_scene = preload("res://Menu/Thumbs_Up/Thumbs_Up.tscn").instantiate()
		add_child.call_deferred(thumbs_up_scene)
		thumbs_up_scene.position = Vector2(832,624)
		chosen_button_type.visible = true
		await get_tree().create_timer(0.1).timeout
		chosen_button_type.visible = false
		await get_tree().create_timer(0.5).timeout
		command_animation_player.play("fade_out")
		await get_tree().create_timer(0.7).timeout
		to_intro_level.emit() #vers Root
		queue_free()
