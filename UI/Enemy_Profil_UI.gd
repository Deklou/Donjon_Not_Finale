extends Control

@onready var ennemy_profil = $"." #pour avoir un contrôle sur la visibilité de cette partie de l'interface

@onready var UI_enemy_Name = $HBoxContainer/Name
@onready var UI_enemy_LVL = $HBoxContainer/LVL

@onready var UI_enemy_HP_stat = $VBoxContainer2/HP
@onready var UI_enemy_MT_stat = $VBoxContainer2/MT
@onready var UI_enemy_CRT_stat = $VBoxContainer2/CRT

@onready var UI_enemy_STR_stat = $VBoxContainer/STR
@onready var UI_enemy_DEX_stat = $VBoxContainer/DEX
@onready var UI_enemy_DEF_stat = $VBoxContainer/DEF

func _ready():
	EntitiesState.visible_enemy_UI.connect(show_enemy_UI)
	StatsSystem.update_enemy_stats.connect(update_enemy_UI)
	StatsSystem.enemy_death.connect(hide_enemy_UI)
	EntitiesState.update_enemy_UI.connect(update_enemy_UI)
	
func update_enemy_UI():
	if EntitiesState.selected_id in GameData.enemy_stats:
		UI_enemy_Name.text = str(GameData.enemy_stats[EntitiesState.selected_id].Name)
		UI_enemy_LVL.text = "Niveau: " + str(GameData.enemy_stats[EntitiesState.selected_id].LVL)
		
		UI_enemy_HP_stat.text = "HP: " + str(GameData.enemy_stats[EntitiesState.selected_id].HP) + "/" + str(GameData.enemy_stats[EntitiesState.selected_id].MAX_HP)
		UI_enemy_MT_stat.text = "Dégâts Totaux: " + str(GameData.enemy_stats[EntitiesState.selected_id].MT)
		UI_enemy_CRT_stat.text = "Critique: " + str(GameData.enemy_stats[EntitiesState.selected_id].CRT)
		
		UI_enemy_STR_stat.text = "STR: " + str(GameData.enemy_stats[EntitiesState.selected_id].STR)
		UI_enemy_DEX_stat.text = "DEX: " + str(GameData.enemy_stats[EntitiesState.selected_id].DEX)
		UI_enemy_DEF_stat.text = "DEF: " + str(GameData.enemy_stats[EntitiesState.selected_id].DEF)
	
func show_enemy_UI():
	ennemy_profil.visible = true
	
func hide_enemy_UI(): #on appelle cette fonction dans le script de l'ennmi s'il est mort
	ennemy_profil.visible = false
