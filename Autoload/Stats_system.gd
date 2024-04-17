extends Node

signal update_player_stats #signal utilisé dès que l'on veut mettre à jour les stats du joueur
signal update_enemy_stats #signal utilisé dès que l'on veut mettre à jour les stats de l'ennemi
signal enemy_death #signal pour avertir de la mort de l'ennemi

signal hide_inventory_UI


########## A SUPPRIMER PLUS TARD ##########

var libération : bool = false
var miséricorde : bool = false
var représailles : bool = false

###########################################


func update_stats():
	GameData.player_LVL = GameData.player_LVL_buffer
	GameData.player_XP = GameData.player_XP_buffer
	GameData.player_MAX_HP = GameData.player_MAX_HP_buffer
	GameData.player_HP = GameData.player_HP_buffer
	GameData.player_CP = GameData.player_CP_buffer
	GameData.player_CRT = GameData.player_CRT_buffer
	GameData.player_STR = GameData.player_STR_buffer
	GameData.player_DEX = GameData.player_DEX_buffer
	GameData.player_DEF = GameData.player_DEF_buffer
	
	if GameData.player_HP < 1 :
		if GameData.secret_triggered == true:
			get_tree().change_scene_to_file("res://Menu/stats_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://Menu/game_over.tscn")
			return
	
	if GameState.weapon_equipped == true:
		GameData.player_MT = GameData.player_STR + GameData.Item[GameState.weapon_equipped_name].Value[0]
	else:
		GameData.player_MT = GameData.player_STR
		
	GameData.player_CRT = GameData.player_CRT + (GameData.player_DEX/4) -1
	GameData.player_base_CRT = GameData.player_base_CRT + (GameData.player_DEX/4) -1
	
	
	########################################################################################################################

													### ENEMY ###

	########################################################################################################################
	
	GameData.enemy_MAX_HP = GameData.enemy_MAX_HP_buffer
	GameData.enemy_HP = GameData.enemy_HP_buffer
	GameData.enemy_MT = GameData.enemy_MT_buffer
	GameData.enemy_CRT = GameData.enemy_CRT_buffer
	GameData.enemy_STR = GameData.enemy_STR_buffer
	GameData.enemy_DEX = GameData.enemy_DEX_buffer
	GameData.enemy_DEF = GameData.enemy_DEF_buffer
	
	if EntitiesState.enemy_id in GameData.enemy_stats and GameData.enemy_stats[EntitiesState.enemy_id].HP < 1 and EntitiesState.enemy_id not in EntitiesState.enemy_states:
		EntitiesState.enemy_states[EntitiesState.enemy_id] = true
		EntitiesState.selected_id = ""
		enemy_death.emit() #envoi du signal vers Enemy_Profil_UI
		hide_inventory_UI.emit() #vers enemy_inventory_ui
		GameData.enemy_defeated +=1
	
	if "Libération" in Inventory.inventory and libération == false:
		GameData.legendary_weapon_acquired += 1
		libération = true
	if "Miséricorde" in Inventory.inventory and miséricorde == false:
		GameData.legendary_weapon_acquired += 1
		miséricorde = true
	if "Représailles" in Inventory.inventory and représailles == false:
		GameData.legendary_weapon_acquired += 1
		représailles = true
		
	if GameData.legendary_weapon_acquired == 3 and GameData.enemy_defeated >= 20:
		GameData.all_objective_completed = true

	update_player_stats.emit() #vers Player_Profil_UI
	update_enemy_stats.emit() #vers Enemy_Profil_UI
