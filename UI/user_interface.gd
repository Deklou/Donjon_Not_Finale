extends CanvasLayer

@onready var interface_left_node : ColorRect = $MarginContainer_left/white_bg_left/interface_left
@onready var logs_histo_button : Button = $MarginContainer_left/white_bg_left/interface_left/histo_logs_button
@onready var histo_is_open : bool = false
@onready var player_lvl_node : RichTextLabel = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/LVL
@onready var player_xp_node : Label = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/XP
@onready var player_cp_node : Label = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/CP
@onready var player_xp_bar_bg_node : ColorRect = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/XP_bar_bg
@onready var player_xp_bar_node : TextureProgressBar = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/XP_bar
@onready var player_hp_node : Label = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Calculated_Stats/HP
@onready var player_crt_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Calculated_Stats/HBoxContainer_CRT
@onready var player_mt_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Calculated_Stats/HBoxContainer_MT
@onready var player_str_node : Label = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Stats/STR
@onready var player_dex_node : Label = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Stats/DEX
@onready var player_def_node : Label = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Stats/DEF
@onready var enemy_hp_node : Label = $MarginContainer_left/white_bg_left/interface_left/Enemy_Profil/Enemy_Calculated_Stats/HP
@onready var enemy_mt_node : HBoxContainer = $MarginContainer_left/white_bg_left/interface_left/Enemy_Profil/Enemy_Calculated_Stats/HBoxContainer_MT
@onready var enemy_crt_node : HBoxContainer = $MarginContainer_left/white_bg_left/interface_left/Enemy_Profil/Enemy_Calculated_Stats/HBoxContainer_CRT
@onready var enemy_str_node : Label = $MarginContainer_left/white_bg_left/interface_left/Enemy_Profil/Enemy_Stats/STR
@onready var enemy_dex_node : Label = $MarginContainer_left/white_bg_left/interface_left/Enemy_Profil/Enemy_Stats/DEX
@onready var enemy_def_node : Label = $MarginContainer_left/white_bg_left/interface_left/Enemy_Profil/Enemy_Stats/DEF

func _ready():
	EntitiesState.hide_UI.connect(hide_UI)
	Logs.remove_logs.connect(show_button)
	GameState.tutorial_start.connect(tutorial_begin)
	GameState.tutorial_end.connect(tutorial_end)
	EntitiesState.show_str_stat_UI.connect(show_str_stat)
	EntitiesState.hide_enemy_hp_stat_UI.connect(hide_enemy_hp_stat)
	EntitiesState.show_enemy_hp_stat_UI.connect(show_enemy_hp_stat)
	EntitiesState.show_def_stat_UI.connect(show_def_stat)
	EntitiesState.show_player_xp_level_UI.connect(show_player_xp_level)
	EntitiesState.show_mt_crt_dex_UI.connect(show_mt_cp_dex)
	var logs_histo_scene = preload("res://UI/logs_histo/logs_histo.tscn").instantiate()
	logs_histo_scene.visible = false
	interface_left_node.add_child(logs_histo_scene, true)

func hide_UI():
	$".".visible = false

func show_UI():
	$".".visible = true

func show_button():
	logs_histo_button.visible = true

func _on_histo_logs_button_pressed():
	if histo_is_open == false:
		logs_histo_button.text = "Retour"
		interface_left_node.get_child(1).visible = false
		interface_left_node.get_child(4).visible = true
		histo_is_open = true
	else:
		logs_histo_button.text = "Historique"
		interface_left_node.get_child(1).visible = true
		interface_left_node.get_child(4).visible = false
		histo_is_open = false

func tutorial_begin():
	var UI_player_stats_array : Array = [player_lvl_node,player_xp_node,player_cp_node,player_xp_bar_bg_node,player_xp_bar_node,player_crt_node,player_mt_node,player_str_node,player_dex_node,player_def_node]
	var UI_enemy_stats_array : Array = [enemy_mt_node,enemy_crt_node,enemy_str_node,enemy_dex_node,enemy_def_node]
	for node in UI_player_stats_array:
		node.visible = false
	for node in UI_enemy_stats_array:
		node.visible = false
		
func hide_enemy_hp_stat():
	enemy_hp_node.visible = false
func show_enemy_hp_stat():
	enemy_hp_node.visible = true

func show_str_stat():
	player_str_node.visible = true
	enemy_str_node.visible = true

func show_def_stat():
	player_def_node.visible = true
	enemy_def_node.visible = true
	
func show_player_xp_level():
	player_xp_node.visible = true
	player_xp_bar_bg_node.visible = true
	player_xp_bar_node.visible = true
	player_lvl_node.visible = true
	player_cp_node.visible = true
	
func show_mt_cp_dex():
	var UI_mt_cp_dex_array : Array = [player_crt_node,player_mt_node,player_dex_node,enemy_crt_node,enemy_mt_node,enemy_dex_node]
	for node in UI_mt_cp_dex_array:
		node.visible = true

func tutorial_end():
	var UI_player_stats_array : Array = [player_lvl_node,enemy_hp_node,player_xp_node,player_cp_node,player_xp_bar_bg_node,player_xp_bar_node,player_crt_node,player_mt_node,player_str_node,player_dex_node,player_def_node]
	var UI_enemy_stats_array : Array = [enemy_mt_node,enemy_crt_node,enemy_str_node,enemy_dex_node,enemy_def_node]
	for node in UI_player_stats_array:
		node.visible = true
	for node in UI_enemy_stats_array:
		node.visible = true
