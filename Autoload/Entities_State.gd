extends Node

##################### VARIABLE PAR DEFAUT #####################
var default_selected_id : String = ""
var default_enemy_id : String = ""
var default_enemy_can_be_attacked_id : String = ""
var default_enemy_can_be_attacked_position : Vector2 = Vector2(0,0)
var default_enemy_that_can_act : String = ""
var default_Root = null
var default_Root_instance = null
var default_player_parent_node : Node = null
var default_player_is_frozen : bool = false
##################### VARIABLES #####################
signal show_enemy_UI #signal envoyé quand on souhaite rendre visible l'interface ennemi
signal hide_enemy_UI #cache le profil de l'ennemi
signal hide_UI #cache l'entièreté de l'interface utilisateur
signal show_enemy_inventory_UI #affiche l'inventaire ennemi
signal hide_enemy_inventory_UI #masque l'inventaire ennemi
signal show_selector_UI(position) #affiche le selecteur
signal change_selector_position_UI(position) #change la position du sélecteur peut impotte sa visbilité
signal hide_selector_UI #cache le selecteur
signal take_damage(Entity) #Signale quand une entité prend des dégâts, pour les effets visuels
signal hide_enemy_hp_stat_UI #masque les hp de l'ennemi d'entraînement
signal show_enemy_hp_stat_UI #affiche les hp des ennemis quand on quitte la zone de l'ennemi d'entraînement
signal show_str_stat_UI #affiche la stat de force pour le joueur et les ennemis
signal show_def_stat_UI #affiche la stat de force pour le joueur et les ennemis
signal show_player_xp_level_UI #affiche l'expérience gagné et le niveau du joueur
signal show_mt_crt_dex_UI #affiche les valeurs calculées et la dex après avoir équipé une arme
signal disable_player_camera #désactive la caméra embarquée dans la scène joueur
signal enable_player_camera #active la caméra embarquée dans la scène joueur
signal player_wait #le joueur veut attendre sans passer par l'interface
var enemy_states = {} #dictionnaire contenant tous les états (vivants ou morts) des ennemis
var selected_id : String #identifiant dont on se sert pour afficher l'interface de l'ennemi
var enemy_id : String #identifiant dont on se sert pour calculer les dégâts
var enemy_can_be_attacked_id : String #identifiant de l'ennemi qui peut être attaqué par le joueur
var enemy_can_be_attacked_position : Vector2 #Position de l'ennemi qui peut être attaqué
var enemy_that_can_act : String #l'identifiant de l'ennemi qui peut agir parmi tous les ennemis
var enemy_triggered_list = [] #liste des ennemis qui ciblent le joueur
var enemy_turn_ended_list = [] #liste des ennemis qui ont déjà agi
var Root
var Root_instance
var player_parent_node : Node  #On récu^père le parent du noeud joueur, qui est le niveau dans lequel il se trouve
var player_is_frozen : bool #permet de décider si le joueur peut se déplacer
##################### RESET VALUE #####################
func _reset_entities_state_value():
	enemy_states.clear()
	selected_id = default_selected_id
	enemy_id = default_enemy_id
	enemy_can_be_attacked_id = default_enemy_can_be_attacked_id
	enemy_can_be_attacked_position = default_enemy_can_be_attacked_position
	enemy_that_can_act = default_enemy_that_can_act
	enemy_triggered_list.clear()
	enemy_turn_ended_list.clear()
	Root = default_Root
	Root_instance = default_Root_instance
	player_parent_node = default_player_parent_node
	player_is_frozen = default_player_is_frozen
##################### READY #####################
func _ready():
	_reset_entities_state_value()
##################### CHOIX ACTION ENNEMI #####################

func take_enemy_action(): #fonction qui choisit la prochaine action de l'ennemi
	if GameData.enemy_stats[enemy_that_can_act].ACT > 0:
		GameState.enemy_has_acted()
		if enemy_that_can_act in GameData.enemy_stats:
			if not GameData.enemy_inventory[enemy_that_can_act].is_empty():
				for item_name in GameData.enemy_inventory[enemy_that_can_act]:
					if not item_name == "":
						if GameData.Item[item_name].Type == "Consumable":
							if GameData.Item[item_name].Sous_Type == "Soin":
								if GameData.enemy_stats[enemy_that_can_act].MAX_HP - GameData.enemy_stats[enemy_that_can_act].HP >= GameData.Item[item_name].Value:
									Inventory._use_enemy_item(item_name)
									if GameData.enemy_stats[EntitiesState.enemy_that_can_act].ACT == 0:
										EntitiesState.enemy_turn_ended_list.append(enemy_that_can_act)
				if enemy_that_can_act not in enemy_turn_ended_list:
					EntitiesState.take_damage_to_enemy("Player", EntitiesState.enemy_that_can_act)
					if GameData.enemy_stats[EntitiesState.enemy_that_can_act].ACT == 0:
						EntitiesState.enemy_turn_ended_list.append(enemy_that_can_act)
	else:
		EntitiesState.enemy_turn_ended_list.append(enemy_that_can_act)
		StatsSystem.update_stats()
			
##################### DEGATS JOUEUR ET ENNEMI #####################	
func take_damage_to_enemy(entity_name: String, dummy_id: String): #fonction pour calculer les dégâts reçus
	if entity_name == "Enemy":
		if randf() < GameData.player_CRT/float(100):
			GameData.enemy_stats[EntitiesState.enemy_id].HP = GameData.enemy_stats[dummy_id].HP + min(-1,GameData.enemy_stats[dummy_id].DEF - GameData.player_MT*2)
			Logs._log_entity_deal_critical_damage("Enemy",entity_name)
		else:
			GameData.enemy_stats[dummy_id].HP = GameData.enemy_stats[dummy_id].HP + min(-1,GameData.enemy_stats[dummy_id].DEF - GameData.player_MT)
			Logs._log_entity_deal_damage("Enemy",entity_name)
		take_damage.emit("Enemy") #Envoie vers chaque script ennemi	
	else:
		if randf() < GameData.enemy_stats[dummy_id].CRT/float(100):
			GameData.player_HP_buffer = GameData.player_HP + min(-1,GameData.player_DEF - GameData.enemy_stats[dummy_id].MT*2) 
			Logs._log_entity_deal_critical_damage("Player",GameData.enemy_stats[dummy_id].Name)
		else:
			GameData.player_HP_buffer = GameData.player_HP + min(-1,GameData.player_DEF - GameData.enemy_stats[dummy_id].MT)
			Logs._log_entity_deal_damage("Player",GameData.enemy_stats[dummy_id].Name)
		take_damage.emit("Player") #Envoi vers script joueur
	StatsSystem.update_stats()
##################### SELECTION #####################

func enemy_selected(position : Vector2, id : String):
	selected_id = id
	Inventory._load_enemy_inventory_UI() ##On charge l'interface à dès qu'on souhaite afficher les informations de l'ennemi
	show_enemy_UI.emit() #envoi du signal vers Enemy_Profil_UI
	show_enemy_inventory_UI.emit() #vers Enemy Inventory UI
	show_selector_UI.emit(position) #vers selector_UI
	StatsSystem.update_stats()
	
func selector_follows_enemy(position : Vector2):
	Inventory._load_enemy_inventory_UI() #On charge l'interface à dès qu'on souhaite afficher les informations de l'ennemi
	StatsSystem.update_stats()
	change_selector_position_UI.emit(position) #vers selector_ui

func enemy_is_deselected():
	hide_selector_UI.emit() #vers selector_UI
	hide_enemy_UI.emit() #envoi du signal vers Enemy_Profil_UI
	hide_enemy_inventory_UI.emit() #vers enemy_inventory_ui
		
##################### MORT #####################
func player_is_dead():
	if GameData.secret_triggered == true:
		EntitiesState.player_parent_node.get_node("Grid_player_2").queue_free()
		GameState.to_stats_screen.emit() #Vers Root
	else:
		var last_player_position = EntitiesState.player_parent_node.get_node("Grid_player_2").global_position
		GameData.player_death_count += 1
		Root = get_tree().root
		Root_instance = preload("res://Menu/game_over.tscn").instantiate()
		Root.add_child(Root_instance)
		EntitiesState.player_parent_node.get_node("Grid_player_2").queue_free()
		Root_instance = preload("res://Entities/Camera/Camera_Death.tscn").instantiate()
		Root_instance.position = last_player_position
		Root.add_child(Root_instance)
	hide_UI.emit() #Vers user_interface

func enemy_is_dead(dummy_id: String) -> bool: #retourne si l'état est présent, et quel état
	return enemy_states.has(dummy_id) and enemy_states[dummy_id]

func enemy_death(dummy_id : String):
	EntitiesState.enemy_states[dummy_id] = true #sert de check pour le process dans la scène de l'ennemi 
	EntitiesState.enemy_is_deselected()
	hide_enemy_UI.emit() #envoi du signal vers Enemy_Profil_UI
	hide_enemy_inventory_UI.emit() #vers enemy_inventory_ui
	XpSystem.gain_xp()
	GameData.enemy_stats.erase(dummy_id) #Une fois qu'on a supprimé l'ennemi du niveau, on supprime sa clé et valeur dans le dictionnaire de stats
	GameData.enemy_inventory.erase(dummy_id) #Une fois qu'on a supprimé l'ennemi du niveau, on supprime son inventaire
	GameData.enemy_defeated +=1
	EntitiesState.enemy_id = ""
	EntitiesState.selected_id = ""
	EntitiesState.enemy_triggered_list.remove_at(EntitiesState.enemy_triggered_list.find(dummy_id))
