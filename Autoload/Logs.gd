extends Node

##################### VARIABLES #####################
var logs : Array = [] #tableau qui contiendra les logs du jeu
var logs_histo : Array = [] #historique des logs
signal add_logs(logs)
signal remove_logs
##################### RESET VALUE #####################
func _reset_logs_value():
	logs.clear()
	logs_histo.clear()
	pass
##################### READY #####################
func _ready():
	_reset_logs_value()
##################### FONCTIONS #####################

func _add_log(string): 
	logs.insert(0, string) # insère le log en première position
	logs_histo.insert(0, string) # insère le log dans l'historique
	add_logs.emit(logs)
	await get_tree().create_timer(1.5 + logs.size()).timeout
	if logs.size() >0:
		remove_logs.emit()
		logs.remove_at(logs.size()-1)
			
func _log_entity_deal_damage(target_type: String, entity_name: String): #on appelle cette fonction quand une entité inflige des dégâts à une autre entité
	if target_type == "Player":
		Logs._add_log(entity_name + " vous a \ninfligé " + str(max(1,GameData.enemy_stats[EntitiesState.enemy_that_can_act].MT - GameData.player_DEF)) + " dégâts")
	elif target_type == "Enemy":
		Logs._add_log("vous avez infligé\n" + str(max(1,GameData.player_MT - GameData.enemy_stats[EntitiesState.enemy_id].DEF))+ " dégâts")

func _log_entity_deal_critical_damage(target_type: String, entity_name: String): #on appelle cette fonction quand une entité inflige un coup critique
	if target_type == "Player":
		Logs._add_log(entity_name + " a \neffectué un coup critique ")
		Logs._add_log("Vous avez reçu " +  str(max(1,GameData.enemy_stats[EntitiesState.enemy_that_can_act].MT*2 - GameData.player_DEF)) + " dégâts")
	elif target_type == "Enemy":
		Logs._add_log("SMAAAASH!!")
		Logs._add_log("vous avez infligé\n" + str(max(1,GameData.player_MT*2 - GameData.enemy_stats[EntitiesState.enemy_id].DEF)) + " dégâts")

func _log_item(action: String, item_name: String):
	if action == "Already_Equiped":
		Logs._add_log(GameState.weapon_equipped_name + " est déjà\néquipée.")
	elif action == "Description":
		Logs._add_log(GameData.Item[item_name].Description)
	elif action == "Statistiques":
		if GameData.Item[item_name].Type != "Weapon": #Si l'item n'est pas une arme on quitte la fonction
			return
		if GameData.Item[item_name].Value[0] != 0: #Si l'arme possède une puissance non nulle
			Logs._add_log("Dégâts totaux +" + str(GameData.Item[item_name].Value[0]))
		if GameData.Item[item_name].Value[1] != 0: #Si l'arme possède un taux de coup critique non nul
			Logs._add_log("Critique +" + str(GameData.Item[item_name].Value[1]))
	elif action == "Open_Chest":
		Logs._add_log("Vous avez ouvert un coffre \nil contenait " + GameData.Item[item_name].Article + " " + item_name + ".")
	elif action == "Cannot_Heal":
		Logs._add_log("Vous n'avez pas besoin de\nvous soigner.")
