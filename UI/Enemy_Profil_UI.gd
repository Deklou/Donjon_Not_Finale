extends Control

@onready var ennemy_profil = $"." #pour avoir un contrôle sur la visibilité de cette partie de l'interface

@onready var UI_enemy_Name = $HBoxContainer/Name
@onready var UI_enemy_LVL = $HBoxContainer/LVL

@onready var UI_enemy_HP_stat = $Enemy_Calculated_Stats/HP
@onready var UI_enemy_MT_stat = $Enemy_Calculated_Stats/HBoxContainer_MT/MT
@onready var UI_enemy_CRT_stat = $Enemy_Calculated_Stats/HBoxContainer_CRT/CRT

@onready var UI_enemy_STR_stat = $Enemy_Stats/STR
@onready var UI_enemy_DEX_stat = $Enemy_Stats/DEX
@onready var UI_enemy_DEF_stat = $Enemy_Stats/DEF

@onready var UI_MVT_stat : Label = $Enemy_Stats/MVT
@onready var UI_ACT_stat : Label = $Enemy_Stats/ACT

############### icône de buff ##################

@onready var MT_Arrow_Up : TextureRect = $Enemy_Calculated_Stats/HBoxContainer_MT/Arrow_Up
@onready var CRT_Arrow_Up : TextureRect = $Enemy_Calculated_Stats/HBoxContainer_CRT/Arrow_Up

func _ready():
	StatsSystem.update_enemy_stats.connect(update_enemy_UI)
	EntitiesState.show_enemy_UI.connect(show_enemy_UI)
	EntitiesState.hide_enemy_UI.connect(hide_enemy_UI)
	
func update_enemy_UI():
	if EntitiesState.selected_id in GameData.enemy_stats and EntitiesState.enemy_id!= "":
		EntitiesState.selected_id = EntitiesState.enemy_id
		UI_enemy_Name.text = str(GameData.enemy_stats[EntitiesState.selected_id].Name)
		UI_enemy_LVL.text = "Niveau: " + str(GameData.enemy_stats[EntitiesState.selected_id].LVL)
		
		UI_enemy_HP_stat.text = "PV: " + str(GameData.enemy_stats[EntitiesState.selected_id].HP) + "/" + str(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP)
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
		if float(GameData.enemy_stats[EntitiesState.selected_id].HP)/float(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP) <= 0.2: #décide de la couleur dès hp en fonction du %
			UI_enemy_HP_stat.modulate = Color(1, 0, 0)  # Rouge
		else:
			UI_enemy_HP_stat.modulate = Color(1, 1, 1)  # Blanc
			
		if GameData.enemy_stats[EntitiesState.selected_id].MT > GameData.enemy_stats[EntitiesState.selected_id].STR:
			UI_enemy_MT_stat.text = "Dégâts Totaux: [color=#66B2FF]" + str(GameData.enemy_stats[EntitiesState.selected_id].MT) + "[/color]"	
			MT_Arrow_Up.visible = true
		if GameData.enemy_stats[EntitiesState.selected_id].CRT > GameData.enemy_base_CRT:
			UI_enemy_CRT_stat.text = "Critique: [color=#66B2FF]" + str(GameData.enemy_stats[EntitiesState.selected_id].CRT) + "[/color]"
			CRT_Arrow_Up.visible = true
	################################################################
	
func show_enemy_UI():
	ennemy_profil.visible = true
	
func hide_enemy_UI(): #on appelle cette fonction dans le script de l'ennmi s'il est mort
	ennemy_profil.visible = false
