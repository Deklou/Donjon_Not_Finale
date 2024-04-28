extends Node

signal UI_stat_button
var xp_result : float

func gain_xp():
	xp_result = (GameData.enemy_stats[EntitiesState.enemy_id].LVL * GameData.enemy_stats[EntitiesState.enemy_id].XP) / GameData.player_LVL
	GameData.player_XP_buffer = GameData.player_XP + xp_result +190
	gain_level()

func gain_level():
	if GameData.player_XP_buffer >=100:
		GameData.player_XP_over_level = GameData.player_XP_buffer/100
		GameData.player_XP_buffer = GameData.player_XP_buffer % 100
		GameData.player_CP_buffer = GameData.player_CP_buffer + GameData.player_XP_over_level
		GameData.player_LVL_buffer = GameData.player_LVL_buffer + GameData.player_XP_over_level
		GameData.player_MAX_HP_buffer = GameData.player_MAX_HP_buffer + GameData.player_XP_over_level
		UI_stat_button.emit() #On envoie ce signal à l'interface du joueur (Player_Profil_UI) pour créer les boutons + et -
	StatsSystem.update_stats()
