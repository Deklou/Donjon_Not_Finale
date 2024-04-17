extends Node

signal update_stats #signal utilisé dès que l'on veut mettre à jour les stats
signal visible_enemy_UI #signal envoyé quand on souhaite rendre visible l'interface ennemi 
signal update_enemy_UI #signal pour mettre à jour l'interface des ennemis
signal ennemy_inventory_UI

var enemy_states = {} #dictionnaire contenant tous les états (vivants ou morts) des ennemis
var selected_id : String = "" #identifiant dont on se sert pour afficher l'interface de l'ennemi
var enemy_id : String = "" #identifirant dont on se sert pour calculer les dégâts

var enemy_triggered_list = [] #liste des ennemis qui ciblent le joueur
var enemy_turn_ended_list = [] #liste des ennemis qui ont déjà agi

#script qui se charge de tous les états des entités du jeu

func take_enemy_action(): #fonction qui choisit la prochaine action de l'ennemi
	Inventory._load_enemy_inventory_UI() #On charge l'interface à chaqué début de tour
	if enemy_id in GameData.enemy_stats:
		var entity_name : String = GameData.enemy_stats[enemy_id].Name
		if not GameData.enemy_inventory[enemy_id].is_empty():
			for item_name in GameData.enemy_inventory[enemy_id]:
				if not item_name == "":
					if GameData.Item[item_name].Type == "Item":
						if GameData.Item[item_name].Sous_Type == "Soin":
							if GameData.enemy_stats[enemy_id].MAX_HP - GameData.enemy_stats[enemy_id].HP >= GameData.Item[item_name].Value:
								Inventory._use_enemy_item(item_name)
								#GameState.enemy_turn_end()
								EntitiesState.enemy_turn_ended_list.append(enemy_id)
	
		if enemy_id not in enemy_turn_ended_list:
			if randf() < GameData.enemy_stats[EntitiesState.enemy_id].CRT/float(100):
				GameData.player_HP_buffer = GameData.player_HP + min(-1,GameData.player_DEF - GameData.enemy_stats[EntitiesState.enemy_id].MT*2) 
				Logs._log_entity_deal_critical_damage("Player",entity_name)
			else:
				GameData.player_HP_buffer = GameData.player_HP + min(-1,GameData.player_DEF - GameData.enemy_stats[EntitiesState.enemy_id].MT)
				Logs._log_entity_deal_damage("Player",entity_name)
			StatsSystem.update_stats()
			#update_stats.emit() #envoi du signal vers Player_Profil_UI
			#GameState.enemy_turn_end()
			EntitiesState.enemy_turn_ended_list.append(enemy_id)
			
func take_damage_to_enemy(entity_name: String, dummy_id: String): #fonction pour calculer les dégâts reçus par un ennemi
	if randf() < GameData.player_CRT/float(100):
		GameData.enemy_stats[EntitiesState.enemy_id].HP = GameData.enemy_stats[EntitiesState.enemy_id].HP + min(-1,GameData.enemy_stats[EntitiesState.enemy_id].DEF - GameData.player_MT*2)
		Logs._log_entity_deal_critical_damage("Enemy",entity_name)
	else:
		GameData.enemy_stats[EntitiesState.enemy_id].HP = GameData.enemy_stats[EntitiesState.enemy_id].HP + min(-1,GameData.enemy_stats[EntitiesState.enemy_id].DEF - GameData.player_MT)
		Logs._log_entity_deal_damage("Enemy",entity_name)
	#EntitiesState.enemy_id = dummy_id
	StatsSystem.update_stats()
	update_stats.emit() #envoi du signal vers Player_Profil_UI
	update_enemy_UI.emit() #envoi du signal vers Enemy_Profil_UI

func enemy_selected():
	Inventory._load_enemy_inventory_UI() ##On charge l'interface à dès qu'on souhaite afficher les informations de l'ennemi
	visible_enemy_UI.emit() #envoi du signal vers Enemy_Profil_UI
	ennemy_inventory_UI.emit() #envoi du signal vers Enemy_Profil_UI
	update_enemy_UI.emit() #envoi du signal vers Enemy_Profil_UI

func enemy_is_dead(dummy_id: String) -> bool: #retourne si l'état est présent, et quel état
	return enemy_states.has(dummy_id) and enemy_states[dummy_id]
