extends CanvasLayer

@onready var interface_left_node : ColorRect = $MarginContainer_left/white_bg_left/interface_left
@onready var logs_histo_button : Button = $MarginContainer_left/white_bg_left/interface_left/histo_logs_button
@onready var histo_is_open : bool = false
@onready var player_lvl_node : RichTextLabel = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/LVL
@onready var player_xp_node : RichTextLabel = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/XP
@onready var player_cp_node : RichTextLabel = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/CP
@onready var player_hp_node : RichTextLabel = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Calculated_Stats/HP
@onready var player_crt_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Calculated_Stats/HBoxContainer_CRT
@onready var player_mt_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Calculated_Stats/HBoxContainer_MT
@onready var player_str_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Stats/STR_HBoxContainer
@onready var player_dex_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Stats/DEX_HBoxContainer
@onready var player_def_node : HBoxContainer = $MarginContainer_right/white_bg_right/interface_right/Player_Profil/Player_Stats/DEF_HBoxContainer
@onready var delimiter_inventory_player_stats : ColorRect = $MarginContainer_right/white_bg_right/interface_right/Delimiter/delimiter_inventory_player_stats
@onready var delimiter_1 : Sprite2D = $MarginContainer_right/white_bg_right/interface_right/Delimiter/delimiter_1
@onready var delimiter_2 : Sprite2D = $MarginContainer_right/white_bg_right/interface_right/Delimiter/delimiter_2
@onready var user_interface_scene #La scène de l'interface utilisateur dans Root
@onready var other_interface_scene #La nscène des interfaces ennemis/objets
##################### READY #####################	
func _ready():
	EntitiesState.hide_UI.connect(hide_UI)
	Logs.remove_logs.connect(show_button)
	GameState.tutorial_start.connect(tutorial_begin)
	GameState.tutorial_end.connect(tutorial_end)
	EntitiesState.show_str_stat_UI.connect(show_str_stat)
	EntitiesState.show_def_stat_UI.connect(show_def_stat)
	EntitiesState.show_player_xp_level_UI.connect(show_player_xp_level)
	EntitiesState.show_mt_crt_dex_UI.connect(show_mt_cp_dex)
	EntitiesState.instanciate_other_UI.connect(create_UI)
	var logs_histo_scene = preload("res://UI/Logs_Histo/logs_histo.tscn").instantiate()
	logs_histo_scene.visible = false
	interface_left_node.add_child(logs_histo_scene, true)
##################### AFFICHAGE #####################	
func hide_UI():
	$".".visible = false
func show_UI():
	$".".visible = true
func show_button():
	logs_histo_button.visible = true
##################### HISTORIQUE LOGS #####################	
func _on_histo_logs_button_pressed():
	if histo_is_open == false:
		logs_histo_button.text = "Retour"
		interface_left_node.get_child(1).visible = false
		interface_left_node.get_child(2).visible = true
		histo_is_open = true
	else:
		logs_histo_button.text = "Historique"
		interface_left_node.get_child(1).visible = true
		interface_left_node.get_child(2).visible = false
		histo_is_open = false
##################### TUTORIEL #####################	
func tutorial_begin():
	var UI_player_stats_array : Array = [player_lvl_node,player_xp_node,player_cp_node,player_crt_node,player_mt_node,player_str_node,player_dex_node,player_def_node]
	var UI_delimiter_array : Array = [delimiter_1, delimiter_2]
	for node in UI_player_stats_array:
		node.visible = false
	for node in UI_delimiter_array:
		node.visible = false
func show_str_stat():
	player_str_node.visible = true
	delimiter_2.visible = true
func show_def_stat():
	player_def_node.visible = true
	delimiter_2.visible = true	
func show_player_xp_level():
	player_xp_node.visible = true
	player_lvl_node.visible = true
	player_cp_node.visible = true
	delimiter_1.visible = true
func show_mt_cp_dex():
	var UI_mt_cp_dex_array : Array = [player_crt_node,player_mt_node,player_dex_node]
	for node in UI_mt_cp_dex_array:
		node.visible = true
	delimiter_2.visible = true
func tutorial_end():
	var UI_player_stats_array : Array = [player_lvl_node,player_xp_node,player_cp_node,player_crt_node,player_mt_node,player_str_node,player_dex_node,player_def_node]
	var UI_delimiter_array : Array = [delimiter_1, delimiter_2]
	for node in UI_player_stats_array:
		node.visible = true
	for node in UI_delimiter_array:
		node.visible = true
##################### AUTRE INTERFACE #####################	
func create_UI(type : String): #instancie l'interface liée à l'identifiant
	user_interface_scene = get_tree().root.get_node("Root").get_node("User_Interface")
	if type == "enemy":
		other_interface_scene = preload("res://UI/Other_Interface/Enemy_UI.tscn").instantiate()
		user_interface_scene.add_child(other_interface_scene)
	elif type == "object":
		other_interface_scene = preload("res://UI/Other_Interface/Object_UI.tscn").instantiate()
		user_interface_scene.add_child(other_interface_scene)
