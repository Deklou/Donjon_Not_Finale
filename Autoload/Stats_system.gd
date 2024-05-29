extends Node

##################### VARIABLE PAR DEFAUT #####################
var default_game_over_boolean : bool = true
##################### VARIABLES #####################
var game_over_boolean : bool #utilisé pour n'instancier qu'une fois la scène de game over
signal update_player_stats #signal utilisé dès que l'on veut mettre à jour les stats du joueur
signal update_enemy_stats #signal utilisé dès que l'on veut mettre à jour les stats de l'ennemi
##################### RESET VALUE #####################
func _reset_stats_system_value():
	game_over_boolean = default_game_over_boolean
##################### READY #####################
func _ready():
	_reset_stats_system_value()
##################### FONCTIONS #####################

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
	
	if GameData.player_HP < 1 and game_over_boolean :
		EntitiesState.player_is_dead()
		game_over_boolean = false
	
	if GameState.weapon_equipped == true:
		GameData.player_MT = GameData.player_STR + GameData.Item[GameState.weapon_equipped_name].Value[0]
	else:
		GameData.player_MT = GameData.player_STR
		
	GameData.player_CRT = snapped(GameData.player_CRT + (GameData.player_DEX/4) - 1, 0)
	GameData.player_base_CRT = snapped((GameData.player_DEX/4) - 1, 0)
	
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
		EntitiesState.enemy_death(EntitiesState.enemy_id)
		
	if not EntitiesState.enemy_triggered_list.is_empty(): #on check s'il existe un ennemi parmis ceux aggro pour lequel on est à portée d'attaque
		GameState.enemy_range_entered = false
		for id in EntitiesState.enemy_triggered_list:
			if GameData.enemy_stats[id].RANGE == true:
				GameState.enemy_range_entered = true
	else:
		GameState.enemy_range_entered = false
		
	GameState.range_check.emit() #envoi à interface down
	GameState.combat_check.emit() #envoi à interface down
	
	update_player_stats.emit() #vers Player_Profil_UI
	update_enemy_stats.emit() #vers Enemy_Profil_UI
