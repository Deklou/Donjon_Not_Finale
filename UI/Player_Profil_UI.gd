extends Control

#On va chercher les différents label de l'interface droite
@onready var Player_Stats_Vbox_Node : VBoxContainer = $Player_Stats
@onready var UI_stat_LVL: RichTextLabel = $LVL
@onready var UI_stat_XP_bar : TextureProgressBar = $XP_bar
@onready var UI_stat_XP : Label = $XP
@onready var UI_stat_CP : Label = $CP
@onready var UI_stat_HP : Label = $Player_Calculated_Stats/HP
@onready var UI_stat_MT : RichTextLabel = $Player_Calculated_Stats/HBoxContainer_MT/MT
@onready var UI_stat_CRT : RichTextLabel = $Player_Calculated_Stats/HBoxContainer_CRT/CRT
@onready var UI_stat_STR : Label = $Player_Stats/STR
@onready var UI_stat_DEX : Label = $Player_Stats/DEX
@onready var UI_stat_DEF : Label = $Player_Stats/DEF
@onready var UI_stat_MVT : Label = $Player_Stats/MVT
@onready var UI_stat_ACT : Label = $Player_Stats/ACT
############### ControlNode ##################
@onready var Button_Stats_Control : Node2D = $Player_Stats/Button_Stat
############### HBoxcontainer ##################
@onready var Hbox_STR : HBoxContainer = $Player_Stats/Button_Stat/HBoxContainer_STR
@onready var Hbox_DEX : HBoxContainer = $Player_Stats/Button_Stat/HBoxContainer_DEX
@onready var Hbox_DEF : HBoxContainer = $Player_Stats/Button_Stat/HBoxContainer_DEF
############### Button ##################
@onready var plus_STR_button : Button = $Player_Stats/Button_Stat/HBoxContainer_STR/plus_STR_button
@onready var minus_STR_button : Button = $Player_Stats/Button_Stat/HBoxContainer_STR/minus_STR_button
@onready var plus_DEX_button : Button = $Player_Stats/Button_Stat/HBoxContainer_DEX/plus_DEX_button
@onready var minus_DEX_button : Button = $Player_Stats/Button_Stat/HBoxContainer_DEX/minus_DEX_button
@onready var plus_DEF_button : Button = $Player_Stats/Button_Stat/HBoxContainer_DEF/plus_DEF_button
@onready var minus_DEF_button : Button = $Player_Stats/Button_Stat/HBoxContainer_DEF/minus_DEF_button
############### Menu de validation ##################
@onready var Hbox_Validation : HBoxContainer = $Player_Stats/Button_Stat/HBoxContainer_Validation
@onready var Button_Validation : Button = $Player_Stats/Button_Stat/HBoxContainer_Validation/Validation_button
@onready var Button_Cancel : Button = $Player_Stats/Button_Stat/HBoxContainer_Validation/Cancel_button
############### Valeurs de copie ##################
var base_player_CP : int #sert de mémoire lors du changement de statsssssdz
var base_player_STR : int #sert de limite minimum et de mémoire lors du changement de stats
var base_player_DEX : float #sert de limite minimum et de mémoire lors du changement de stats
var base_player_DEF : int #sert de limite minimum et de mémoire lors du changement de stats
############### icône de buff ##################
@onready var MT_Arrow_Up : TextureRect = $Player_Calculated_Stats/HBoxContainer_MT/Arrow_Up
@onready var CRT_Arrow_Up : TextureRect = $Player_Calculated_Stats/HBoxContainer_CRT/Arrow_Up
##################### READY #####################
func _ready(): 
	StatsSystem.update_player_stats.connect(update_player_UI) #dès qu'on met à jour les stats d'une entité, on met à jour l'interface
	XpSystem.UI_stat_button.connect(stat_modifier) 
	GameState.show_mvt_act_stats.connect(update_player_UI)
	GameState.signal_player_input_cant_move.connect(player_input_cant_move)
	update_player_UI()
##################### UPDATE STATS #####################	
func update_player_UI(): #update l'interface avec les valeurs du joueur
	if GameState.level_up == false:
		UI_stat_LVL.text = "Niveau:   " + str(GameData.player_LVL)
	############### XP ################
	UI_stat_XP.text = "Exp:   " + str(GameData.player_XP)
	UI_stat_XP_bar.update_xp_progress(GameData.player_XP)
	###################################
	UI_stat_CP.text = "Point de compétence:  " + str(GameData.player_CP)
	UI_stat_HP.text = "PV: " + str(GameData.player_HP) + "/" + str(GameData.player_MAX_HP)
	UI_stat_MT.text = "Dégâts Totaux: " + str(GameData.player_MT)
	UI_stat_CRT.text = "Critique: " + str(GameData.player_CRT)
	UI_stat_STR.text = "FRC: " + str(GameData.player_STR)
	UI_stat_DEX.text = "DEX: " + str(GameData.player_DEX)
	UI_stat_DEF.text = "DEF: " + str(GameData.player_DEF)
	UI_stat_MVT.text = "MVT: " + str(GameData.player_current_movement_point)
	UI_stat_ACT.text = "ACT: " + str(GameData.player_current_action_point)
	
	if not EntitiesState.enemy_triggered_list.is_empty():
		UI_stat_MVT.visible = true
		UI_stat_ACT.visible = true
	else:
		UI_stat_MVT.visible = false
		UI_stat_ACT.visible = false
	
	########################### flèches ###########################
	MT_Arrow_Up.visible = false
	CRT_Arrow_Up.visible = false
	########################### Couleurs ###########################
	
	if float(GameData.player_HP)/float(GameData.player_MAX_HP) <= 0.2: #décide de la couleur dès hp en fonction du %
		UI_stat_HP.modulate = Color(1, 0, 0)  # Rouge
	else:
		UI_stat_HP.modulate = Color(1, 1, 1)  # Blanc
		
	if GameState.weapon_equipped == true:
		if GameData.player_MT > GameData.player_STR:
			UI_stat_MT.text = "Dégâts Totaux: [color=#66B2FF]" + str(GameData.player_MT) + "[/color]"
			MT_Arrow_Up.visible = true
		if GameData.player_CRT > GameData.player_base_CRT:
			UI_stat_CRT.text = "Critique: [color=#66B2FF]" + str(GameData.player_CRT) + "[/color]"
			CRT_Arrow_Up.visible = true

##################### LEVEL UP #####################
func stat_modifier():
	base_player_CP = GameData.player_CP_buffer #chaque montée de niveau, on copie les anciennes stats du joueur
	base_player_STR = GameData.player_STR
	base_player_DEX = GameData.player_DEX
	base_player_DEF = GameData.player_DEF
	Button_Stats_Control.visible = true
	if is_inside_tree():
		for i in range(0,3):
			UI_stat_LVL.text = "[b]" + "Niveau:   " + str(GameData.player_LVL) + "[/b]"
			UI_stat_LVL.modulate = Color(1, 1, 0) #Jaune
			await get_tree().create_timer(0.3).timeout
			UI_stat_LVL.modulate = Color(1, 1, 1) #Blanc
			UI_stat_LVL.text = "Niveau:   " + str(GameData.player_LVL)
			await get_tree().create_timer(0.1).timeout
	else:
		return
	GameState.level_up = false
	update_player_UI()
##################### LEVEL UP BUTTON #####################
func _on_plus_str_button_pressed():
	if GameData.player_CP > 0 and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		Hbox_Validation.visible = true
		GameState.Ui_Inventory_is_locked = true #on désactive l'accès à l'inventaire
		GameData.player_STR_buffer = GameData.player_STR_buffer + 1
		GameData.player_CP_buffer = GameData.player_CP_buffer - 1
		GameState.player_has_acted()
		StatsSystem.update_stats()
		GameState.player_turn_end()
func _on_minus_str_button_pressed():
	if GameData.player_CP >= 0 and GameData.player_STR_buffer > base_player_STR and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		Hbox_Validation.visible = true
		GameState.Ui_Inventory_is_locked = true #on désactive l'accès à l'inventaire
		GameData.player_STR_buffer = GameData.player_STR_buffer - 1
		GameData.player_CP_buffer = GameData.player_CP_buffer + 1
		GameState.player_has_acted()
		StatsSystem.update_stats()
		GameState.player_turn_end()

func _on_plus_dex_button_pressed():
	if GameData.player_CP > 0 and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		Hbox_Validation.visible = true
		GameState.Ui_Inventory_is_locked = true #on désactive l'accès à l'inventaire
		GameData.player_DEX_buffer = GameData.player_DEX_buffer + 1
		GameData.player_CP_buffer = GameData.player_CP_buffer - 1
		GameState.player_has_acted()
		StatsSystem.update_stats()
		GameState.player_turn_end()
func _on_minus_dex_button_pressed():
	if GameData.player_CP >= 0 and GameData.player_DEX_buffer > base_player_DEX and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		Hbox_Validation.visible = true
		GameState.Ui_Inventory_is_locked = true #on désactive l'accès à l'inventaire
		GameData.player_DEX_buffer = GameData.player_DEX_buffer - 1
		GameData.player_CP_buffer = GameData.player_CP_buffer + 1
		GameState.player_has_acted()
		StatsSystem.update_stats()
		GameState.player_turn_end()

func _on_plus_def_button_pressed():
	if GameData.player_CP > 0 and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		Hbox_Validation.visible = true
		GameState.Ui_Inventory_is_locked = true #on désactive l'accès à l'inventaire
		GameData.player_DEF_buffer = GameData.player_DEF_buffer + 1
		GameData.player_CP_buffer = GameData.player_CP_buffer - 1
		GameState.player_has_acted()
		StatsSystem.update_stats()
		GameState.player_turn_end()
func _on_minus_def_button_pressed():
	if GameData.player_CP >= 0 and GameData.player_DEF_buffer > base_player_DEF and GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		Hbox_Validation.visible = true
		GameState.Ui_Inventory_is_locked = true #on désactive l'accès à l'inventaire
		GameData.player_DEF_buffer = GameData.player_DEF_buffer - 1
		GameData.player_CP_buffer = GameData.player_CP_buffer + 1
		GameState.player_has_acted()
		StatsSystem.update_stats()
		GameState.player_turn_end()
##################### VALIDATION #####################
func _on_validation_button_pressed():
	GameState.Ui_Inventory_is_locked = false #on réactive l'accès à l'inventaire
	Button_Stats_Control.visible = false
	Hbox_Validation.visible = false
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()

func _on_cancel_button_pressed():
	GameState.Ui_Inventory_is_locked = false #on réactive l'accès à l'inventaire
	Hbox_Validation.visible = false
	GameData.player_CP_buffer = base_player_CP
	GameData.player_STR_buffer = base_player_STR
	GameData.player_DEX_buffer = base_player_DEX
	GameData.player_DEF_buffer = base_player_DEF
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()
##################### CANT MOVE #####################
func player_input_cant_move():
	if is_inside_tree():
		UI_stat_MVT.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.1).timeout
		UI_stat_MVT.modulate = Color(1, 1, 1)
	else:
		return
##################### DESCRIPTION #####################
func _on_area_2d_mouse_entered():
	var str_description_scene = preload("res://UI/Stats_Description/STR_Description.tscn").instantiate()
	UI_stat_STR.add_child(str_description_scene, true)
func _on_area_2d_mouse_exited():
	UI_stat_STR.get_child(0).queue_free()
