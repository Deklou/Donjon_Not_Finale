extends Node

#Script qui se charge de la partie purement fonctionnelle de l'inventaire

##################### VARIABLES #####################
var inventory : Array = [] #l'inventaire est un tableau/liste, vide au départ
signal item_added(inventory)
signal update_enemy_inventory_UI(enemy_inventory) #signal utilisé pour update l'interface de l'inventaire enenmi
signal entity_heal(entity_name) #signal lorsque le joueur ou un enemi se soigne
##################### RESET VALUE #####################
func _reset_inventory_value():
	inventory.clear()
##################### READY #####################
func _ready():
	_reset_inventory_value()
##################### FONCTIONS #####################

func _add_item(item_name): #ajouter un item dans l'inventaire
	inventory.append(GameData.Item[item_name].Name)
	item_added.emit(inventory) #dès qu'un item est ajouté à l'inventaire, on émet un signal dans l'interface
	if item_name == "Libération" or item_name == "Représailles" or item_name == "Miséricorde":
		GameData.legendary_weapon_acquired +=1
	if item_name == "Kojirō":
		GameState.kojiro_was_obtained = true
	
func _remove_item(item_name): #jeter un item de l'inventaire
	if GameState.double_remove_call == false:
		var index = inventory.find(item_name)
		if GameData.Item[item_name].Type == "Consumable" and index >= 0: #si l'inventaire est vide, l'index renvoi -1
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
	GameState.player_turn_end()
	StatsSystem.update_stats()
	

func _use_item(item_name): #utiliser un item.
	if GameData.Item[item_name].Type == "Consumable": #Ici on ne s'intéresse qu'aux soins
		GameData.player_HP_buffer = GameData.player_HP_buffer + GameData.Item[item_name].Value
		if GameData.player_HP_buffer > GameData.player_MAX_HP_buffer:
			GameData.player_HP_buffer = GameData.player_MAX_HP_buffer
		entity_heal.emit("Player") #Vers script joueur
	elif GameData.Item[item_name].Type == "Weapon" and GameData.Item[item_name].Equiped == false: 
		if GameState.first_weapon_equiped == false:
			EntitiesState.show_mt_crt_dex_UI.emit() #vers user_interface
			GameState.first_weapon_equiped = true
		GameData.Item[item_name].Equiped = true
		GameState.weapon_equipped = true #Si une arme est équipée, on met à jour l'état
		GameState.weapon_equipped_name = item_name
		GameData.player_MT_buffer = GameData.player_STR_buffer + GameData.Item[item_name].Value[0]
		GameData.player_CRT_buffer = GameData.player_CRT_buffer + GameData.Item[item_name].Value[1]
		GameState.player_has_acted() #que pour les armes car si on utilise un objet, on le supprime également donc act deux fois
	StatsSystem.update_stats()
	GameState.player_turn_end()
	
func _exchange_item(item_name): #échanger d'arme
	if GameData.Item[item_name].Type == "Weapon":
		if GameState.weapon_equipped == true and GameState.weapon_equipped_name != item_name:
			GameData.Item[GameState.weapon_equipped_name].Equiped = false
			GameData.player_MT_buffer = GameData.player_STR_buffer
			GameData.player_CRT_buffer = GameData.player_CRT_buffer - GameData.Item[GameState.weapon_equipped_name].Value[1]
			GameData.Item[item_name].Equiped = true
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
	entity_heal.emit(EntitiesState.enemy_id) #Vers script ennemi
	Logs._add_log(str(GameData.enemy_stats[EntitiesState.enemy_id].Name) + " s'est restauré " + str(GameData.Item[item_name].Value) + " PV")
	StatsSystem.update_stats()
	
func _remove_enemy_item(item_name):
	var enemy_item_index = GameData.enemy_inventory[EntitiesState.enemy_id].find(item_name)
	GameData.enemy_inventory[EntitiesState.enemy_id].remove_at(enemy_item_index)
	StatsSystem.update_stats()
	
func _load_enemy_inventory_UI():
	if EntitiesState.selected_id in GameData.enemy_inventory:
		update_enemy_inventory_UI.emit(GameData.enemy_inventory[EntitiesState.selected_id]) #vers Enemy_Inventory_UI
		StatsSystem.update_stats()
	
