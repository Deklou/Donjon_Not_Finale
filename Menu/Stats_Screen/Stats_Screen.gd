extends CanvasLayer

@onready var title_label : RichTextLabel = $Black_Background_ColorRect/Title/TitleLabel
@onready var stage_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Stage/Stage_Label
@onready var weapon_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Weapon/Weapon_Label
@onready var enemy_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Enemy/Enemy_Label
@onready var secret_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Secret/Secret_Label
@onready var time_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Time/Time_Label
@onready var death_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Death/Death_Label
@onready var level_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Level/Level_Label
@onready var stats_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/Stats_Label
@onready var stage_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Stage/Stage_Result_Label
@onready var weapon_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Weapon/Weapon_Result_Label
@onready var enemy_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Enemy/Enemy_Result_Label
@onready var secret_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Secret/Secret_Result_Label
@onready var time_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Time/Time_Result_Label
@onready var death_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Death/Death_Result_Label
@onready var variable_stage_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Stage/Variable_Stage_Result_Label
@onready var variable_weapon_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Weapon/Variable_Weapon_Result_Label
@onready var variable_enemy_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Enemy/Variable_Enemy_Result_Label
@onready var variable_secret_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Secret/Variable_Secret_Result_Label
@onready var variable_time_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Time/Variable_Time_Result_Label
@onready var variable_death_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Death/Variable_Death_Result_Label
@onready var variable_level_result_label : RichTextLabel = $Black_Background_ColorRect/ScrollContainer/Category_VBoxContainer/HBox_Level/Variable_Level_Result_Label
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
	
	var index = min(GameData.player_death_count, GameData.death_string.size() - 1)
	death_label.bbcode_text = "[b][font_size=30]" + GameData.death_string[index] + "[/font_size][/b]"
	
	if GameState.ending_triggered == true:
		level_label.visible = true
		stats_label.visible = true
		title_label.bbcode_text = "[b][font_size=50]" + "RESULTATS" + "[/font_size][/b]"
		variable_stage_result_label.text =  "[font_size=30]" + "   1" + "[/font_size]"
		variable_weapon_result_label.text =  "[font_size=30]" + "   " + str(GameData.legendary_weapon_acquired) + "[/font_size]"
		variable_enemy_result_label.text =  "[font_size=30]" + "   " + str(GameData.enemy_defeated) + "[/font_size]"
		variable_secret_result_label.text =  "[font_size=30]" + "   0" + "[/font_size]"
		variable_time_result_label.text =  "[font_size=30]" + " " + str(int(int(GameData.timer) / 3600.0)) + "h " + str((int(GameData.timer) % 3600) / 60) + "min " + str(int(GameData.timer) % 60) + "s" + "[/font_size]"
		variable_death_result_label.text =  "[font_size=30]" + "   " + str(GameData.player_death_count) + "[/font_size]"
		variable_level_result_label.text = "[font_size=30]" + "   " + str(GameData.player_LVL) + "[/font_size]"
		death_label.bbcode_text = "[font_size=30]" + "Nombre de mort                                                                                   " + variable_death_result_label.text + "[/font_size]"
		stats_label.text = "[font_size=30]" + "HP: " + str(GameData.player_MAX_HP) + "  FRC: " + str(GameData.player_STR) + "  DEX: " + str(GameData.player_DEX) + "  DEF: " + str(GameData.player_DEF) + "  MVT: " + str(GameData.player_MAX_movement_point) + "  ACT: " + str(GameData.player_MAX_action_point) +"[/font_size]"
		if GameData.secret_triggered == true:
			variable_secret_result_label.text = "   1"
		if GameState.kojiro_was_obtained == true:
			special_sprite_2d.visible = true
	
	command_animation_player.play("fade_in")
	stage_label.bbcode_text = "[font_size=30]" + stage_label.text + "                                                                                               " + variable_stage_result_label.text + "[/font_size]"
	weapon_label.bbcode_text = "[font_size=30]" + weapon_label.text + "                                                            " + variable_weapon_result_label.text + "[/font_size]"
	enemy_label.bbcode_text = "[font_size=30]" + enemy_label.text + "                                                                                " + variable_enemy_result_label.text + "[/font_size]"
	secret_label.bbcode_text = "[font_size=30]" + secret_label.text + "                                                                                                    " + variable_enemy_result_label.text + "[/font_size]"
	time_label.bbcode_text = "[font_size=30]" + time_label.text + "                                                                                      " + variable_time_result_label.text + "[/font_size]"
	level_label.bbcode_text = "[font_size=30]" + level_label.text + "                                                                                                     " + variable_level_result_label.text + "[/font_size]"
	
	stage_result_label.bbcode_text = "[font_size=30]" + stage_result_label.text + "[/font_size]"
	weapon_result_label.bbcode_text = "[font_size=30]" + weapon_result_label.text + "[/font_size]"
	enemy_result_label.bbcode_text = "[font_size=30]" + enemy_result_label.text + "[/font_size]"
	secret_result_label.bbcode_text = "[font_size=30]" + secret_result_label.text + "[/font_size]"
	time_result_label.bbcode_text = "[font_size=30]" + time_result_label.text + "[/font_size]"

func _on_area_2d_mouse_entered():
	if GameState.ending_triggered == true or GameData.player_death_count > 0:
		restart_button_sprite_2d.visible = false
		restart_button_green_sprite_2d.visible = not restart_button_sprite_2d.visible
	else:
		button_sprite_2d.visible = false
		button_green_sprite_2d.visible = not button_sprite_2d.visible

func _on_area_2d_mouse_exited():
	if GameState.ending_triggered == true or GameData.player_death_count > 0:
		restart_button_sprite_2d.visible = true
	else:
		button_sprite_2d.visible = true
	
func _process(_delta):
	if GameState.ending_triggered == true or GameData.player_death_count > 0:
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
