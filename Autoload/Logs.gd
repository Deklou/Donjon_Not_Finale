extends Node

var logs = [] #tableau qui contiendra les logs du jeu
signal update_logs(logs)

#Script qui décrit le fonctionnement du système de log

func _add_log(string): 
	logs.append(string)
	if logs.size() >=1 : #si le tableau n'est pas vide
		if logs.size() >=2: #si le tableau contient au moins deux logs
			if string == logs[logs.size()-2]: #si deux entrées identiques se suivent
				logs.remove_at(logs.size()-1) #on supprime le dernière entrée
		update_logs.emit(logs) #dès qu'on ajoute une entrée, on envoi un signal vers l'interface (UI_logs)
		await get_tree().create_timer(2.0).timeout
		logs.remove_at(logs.size()-1) #on supprime les entrées au fur et à mesure 
		update_logs.emit(logs) #on update une nouvelle fois car l'entrée est supprimée (UI_logs)


func _log_entity_deal_damage(target_type: String, entity_name: String): #on appelle cette fonction quand une entité inflige des dégâts à une autre entité
	if target_type == "Player":
		Logs._add_log(entity_name + " vous a \ninfligé " + str(max(1,GameData.enemy_stats[EntitiesState.enemy_id].MT - GameData.player_DEF)) + " dégâts")
	elif target_type == "Enemy":
		Logs._add_log("vous avez infligé\n" + str(max(1,GameData.player_MT - GameData.enemy_stats[EntitiesState.enemy_id].DEF))+ " dégâts")

func _log_entity_deal_critical_damage(target_type: String, entity_name: String): #on appelle cette fonction quand une entité inflige un coup critique
	if target_type == "Player":
		Logs._add_log(entity_name + " a \neffectué un coup critique ")
		Logs._add_log("Vous avez reçu " +  str(max(1,GameData.enemy_stats[EntitiesState.enemy_id].MT*2 - GameData.player_DEF)) + " dégâts")
	elif target_type == "Enemy":
		Logs._add_log("SMAAAASH!!")
		Logs._add_log("vous avez infligé\n" + str(max(1,GameData.player_MT*2 - GameData.enemy_stats[EntitiesState.enemy_id].DEF)) + " dégâts")


func _log_item(action: String, item_name: String):
	if action == "Already_Equiped":
		Logs._add_log(GameState.weapon_equipped_name + " est déjà\néquipée")
	elif action == "Description":
		Logs._add_log(GameData.Item[item_name].Description)
	elif action == "Open_Chest":
		Logs._add_log("Vous avez ouvert un coffre \nil contenait l'objet \n" + item_name)
