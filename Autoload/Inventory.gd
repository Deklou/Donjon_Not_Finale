extends Node

#Script qui se charge de la partie purement fonctionnelle de l'inventaire

var inventory = [] #l'inventaire est un tableau/liste, vide au départ
signal item_added(inventory)
signal update_enemy_inventory_UI(enemy_inventory) #signal utilisé pour update l'interface de l'inventaire enenmi

func _add_item(item_name): #ajouter un item dans l'inventaire
	inventory.append(GameData.Item[item_name].Name)
	item_added.emit(inventory) #dès qu'un item est ajouté à l'inventaire, on émet un signal dans l'interface
	
func _remove_item(item_name): #jeter un item de l'inventaire
	if GameState.double_remove_call == false:
		var index = inventory.find(item_name)
		if GameData.Item[item_name].Type == "Item" and index >= 0: #si l'inventaire est vide, l'index renvoi -1
			inventory.remove_at(index)
		elif GameData.Item[item_name].Type == "Weapon": #Pour les armes, la fonction jeter a d'autre cas d'utilisations
			if GameData.Item[item_name].Equiped == false:
				if index >= 0: #si l'arme n'est pas équipée, on peut la supprimer de l'inventaire
					inventory.remove_at(index) 
			else: #si l'arme est équippée, on déséquipe l'arme et update les stats du joueur
				GameData.player_MT_buffer = GameData.player_STR_buffer
				GameData.player_CRT_buffer = GameData.player_CRT_buffer - GameData.Item[item_name].Value[1]
				GameData.Item[item_name].Equiped = false
				GameState.weapon_equipped = false
		GameState.double_remove_call = true
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()
	

func _use_item(item_name): #utiliser un item.
	if GameData.Item[item_name].Type == "Item": #Ici on ne s'intéresse qu'aux soins
		GameData.player_HP_buffer = GameData.player_HP_buffer + GameData.Item[item_name].Value
		if GameData.player_HP_buffer > GameData.player_MAX_HP_buffer:
			GameData.player_HP_buffer = GameData.player_MAX_HP_buffer
	elif GameData.Item[item_name].Type == "Weapon" and GameData.Item[item_name].Equiped == false: 
		GameData.Item[item_name].Equiped = true
		GameState.weapon_equipped = true #Si une arme est équipée, on met à jour l'état
		GameState.weapon_equipped_name = item_name
		GameData.player_MT_buffer = GameData.player_STR_buffer + GameData.Item[item_name].Value[0]
		GameData.player_CRT_buffer = GameData.player_CRT_buffer + GameData.Item[item_name].Value[1]
	GameState.player_has_acted()
	StatsSystem.update_stats()
	GameState.player_turn_end()

########################################################################################################################

													### ENEMY ###

########################################################################################################################

func _use_enemy_item(item_name):
	GameData.enemy_stats[EntitiesState.enemy_id].HP = GameData.enemy_stats[EntitiesState.enemy_id].HP + GameData.Item[item_name].Value
	if GameData.enemy_stats[EntitiesState.enemy_id].HP > GameData.enemy_stats[EntitiesState.enemy_id].MAX_HP:
		GameData.enemy_stats[EntitiesState.enemy_id].HP = GameData.enemy_stats[EntitiesState.enemy_id].MAX_HP
	_remove_enemy_item(item_name)
	StatsSystem.update_stats()
	GameState.enemy_turn_end()
	
func _remove_enemy_item(item_name):
	var enemy_item_index = GameData.enemy_inventory[EntitiesState.enemy_id].find(item_name)
	GameData.enemy_inventory[EntitiesState.enemy_id].remove_at(enemy_item_index)
	StatsSystem.update_stats()
	
func _load_enemy_inventory_UI():
	if EntitiesState.selected_id in GameData.enemy_inventory:
		update_enemy_inventory_UI.emit(GameData.enemy_inventory[EntitiesState.selected_id]) #vers Enemy_Inventory_UI
		StatsSystem.update_stats()
	
