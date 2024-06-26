extends Control

var enemy_profil_id : String #identifiant de l'interface, le même que l'ennemi dont elel est associée
@onready var ennemy_profil = $"." #pour avoir un contrôle sur la visibilité de cette partie de l'interface
@onready var UI_enemy_Name : RichTextLabel = $VBoxContainer/Name
@onready var UI_enemy_LVL : RichTextLabel = $VBoxContainer/LVL
@onready var UI_enemy_HP_stat : RichTextLabel = $Enemy_Calculated_Stats/HP
@onready var UI_enemy_stat_HP_BAR : TextureProgressBar = $Enemy_Calculated_Stats/Enemy_HP_Bar/Enemy_HP_Bar_TextureProgressBar
@onready var UI_enemy_MT_stat : RichTextLabel = $Enemy_Calculated_Stats/HBoxContainer_MT/MT
@onready var UI_enemy_CRT_stat : RichTextLabel = $Enemy_Calculated_Stats/HBoxContainer_CRT/CRT
@onready var UI_enemy_STR_stat : RichTextLabel = $Enemy_Stats/STR_HBoxContainer/STR
@onready var UI_enemy_DEX_stat : RichTextLabel = $Enemy_Stats/DEX_HBoxContainer/DEX
@onready var UI_enemy_DEF_stat : RichTextLabel = $Enemy_Stats/DEF_HBoxContainer/DEF
@onready var UI_MVT_stat : RichTextLabel = $Enemy_Stats/MVT_HBoxContainer/MVT
@onready var UI_ACT_stat : RichTextLabel = $Enemy_Stats/ACT_HBoxContainer/ACT
############### icône de buff ##################
@onready var MT_Arrow_Up : TextureRect = $Enemy_Calculated_Stats/HBoxContainer_MT/Arrow_Up
@onready var CRT_Arrow_Up : TextureRect = $Enemy_Calculated_Stats/HBoxContainer_CRT/Arrow_Up
##################### READY #####################
func _ready():
	enemy_profil_id = EntitiesState.enemy_id
	StatsSystem.update_enemy_stats.connect(update_enemy_UI)
	EntitiesState.show_other_UI.connect(show_enemy_UI)
	EntitiesState.hide_other_UI.connect(hide_enemy_UI)
##################### UPDATE INTERFACE #####################	
func update_enemy_UI():
	if EntitiesState.selected_id in GameData.enemy_stats and EntitiesState.enemy_id!= "" and enemy_profil_id == EntitiesState.selected_id:
		UI_enemy_Name.text = str(GameData.enemy_stats[EntitiesState.selected_id].Name)
		UI_enemy_LVL.text = "Niveau: " + str(GameData.enemy_stats[EntitiesState.selected_id].LVL)
		UI_enemy_stat_HP_BAR.value = float(GameData.enemy_stats[EntitiesState.selected_id].HP)*100/float(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP)
		UI_enemy_MT_stat.text = "Dégâts Totaux: " + str(GameData.enemy_stats[EntitiesState.selected_id].MT)
		UI_enemy_CRT_stat.text = "Critique: " + str(GameData.enemy_stats[EntitiesState.selected_id].CRT)
		
		UI_enemy_STR_stat.text = "FRC: " + str(GameData.enemy_stats[EntitiesState.selected_id].STR)
		UI_enemy_DEX_stat.text = "DEX: " + str(GameData.enemy_stats[EntitiesState.selected_id].DEX)
		UI_enemy_DEF_stat.text = "DEF: " + str(GameData.enemy_stats[EntitiesState.selected_id].DEF)
		
		UI_MVT_stat.text = "MVT: " + str(GameData.enemy_stats[EntitiesState.selected_id].MVT)
		UI_ACT_stat.text = "ACT: " + str(GameData.enemy_stats[EntitiesState.selected_id].ACT)
	
		########################### flèches ###########################
	
		MT_Arrow_Up.visible = false
		CRT_Arrow_Up.visible = false
	
		########################### Couleurs ###########################
		if float(GameData.enemy_stats[EntitiesState.selected_id].HP)*100/float(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP) <= 20: #décide de la couleur dès hp en fonction du %
			UI_enemy_HP_stat.text = "[b][color=#FF0000]PV: " + str(GameData.enemy_stats[EntitiesState.selected_id].HP) + "/" + str(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP) + "[/color][/b]"  # Rouge
			UI_enemy_stat_HP_BAR.tint_progress = Color(255,0,0,255)
		elif GameData.enemy_stats[EntitiesState.selected_id].HP == GameData.enemy_stats[EntitiesState.selected_id].MAX_HP:
			UI_enemy_HP_stat.text = "[b][color=#3EE657]PV: " + str(GameData.enemy_stats[EntitiesState.selected_id].HP) + "/" + str(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP) + "[/color][/b]" #Vert
			UI_enemy_stat_HP_BAR.tint_progress = Color(1,230,1,255)
		else:
			UI_enemy_HP_stat.text = "[b]PV: " + str(GameData.enemy_stats[EntitiesState.selected_id].HP) + "/" + str(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP) + "[/b]"  # Blanc
			UI_enemy_stat_HP_BAR.tint_progress = Color(255,255,255,255)
			
		if GameData.enemy_stats[EntitiesState.selected_id].MT > GameData.enemy_stats[EntitiesState.selected_id].STR:
			UI_enemy_MT_stat.text = "Dégâts Totaux: [color=#66B2FF]" + str(GameData.enemy_stats[EntitiesState.selected_id].MT) + "[/color]"	
			MT_Arrow_Up.visible = true
		if GameData.enemy_stats[EntitiesState.selected_id].CRT > GameData.enemy_stats[EntitiesState.selected_id].BASE_CRT:
			UI_enemy_CRT_stat.text = "Critique: [color=#66B2FF]" + str(GameData.enemy_stats[EntitiesState.selected_id].CRT) + "[/color]"
			CRT_Arrow_Up.visible = true
		################################################################
		if EntitiesState.selected_id == "special":
			UI_enemy_HP_stat.visible = false
		else:
			UI_enemy_HP_stat.visible = true
##################### AFFICHAGE #####################	
func show_enemy_UI():
	if enemy_profil_id == EntitiesState.selected_id: 
		ennemy_profil.visible = true
	else:
		ennemy_profil.visible = false
func hide_enemy_UI(): #on appelle cette fonction dans le script de l'ennmi s'il est mort
	if enemy_profil_id == EntitiesState.selected_id:
		ennemy_profil.visible = false
