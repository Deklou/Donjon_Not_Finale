extends ColorRect

@onready var vbox_node = $UI_Inventory/VBoxContainer #le noeud auquel on souhaite ajouter les objets 
@onready var validation_node = $Validation_menu/MarginContainer/Validation #le noeud sur lequel se trouve le menu de validation

@onready var use_button = $Validation_menu/MarginContainer/Validation/Use_button
@onready var throw_button = $Validation_menu/MarginContainer/Validation/Throw_button
@onready var cancel_button = $Validation_menu/MarginContainer/Validation/Cancel_button

func _ready():
	Inventory.item_added.connect(update_inventory) #dès qu'on ajoute un item dans l'inventaire, on update l'interface
	validation_node.visible = false

func update_inventory(inventory: Array):
	for child in vbox_node.get_children():
		child.free() # Supprimer tous les enfants du VBoxContainer avant de les recréer
	for item_name in inventory: #Pour chaque objet de l'inventaire, on appelle la scène de l'item
		var item_button = preload("res://UI/Inventory_Item.tscn").instantiate()
		var item_icon = item_button.get_node("Icon")
		vbox_node.add_child(item_button)
		item_button.text = item_name
		item_button.name = item_name #pour debug plus facilement
		if GameData.Item[item_name].Type == "Weapon":
			item_icon.texture = preload("res://Sprites/UI_icon/weapon.png")
			if GameState.weapon_equipped == true and GameState.weapon_equipped_name == item_name:
				var equipped_label = item_button.get_node("Equipped_Label")
				equipped_label.visible = true
		elif GameData.Item[item_name].Type == "Consumable":
			item_icon.texture = preload("res://Sprites/UI_icon/consumable.png")
		elif GameData.Item[item_name].Type == "Special":
			item_icon.texture = GameData.Item[item_name].Icon
			
		item_button.pressed.connect(func():validation_menu(item_button, item_name)) #si on sélectionne l'objet


func validation_menu(item_button, item_name):
	if GameState.is_ennemy_turn == false and GameData.player_current_action_point > 0:
		if GameState.Ui_Inventory_is_locked == true : #Si le flag est vrai, on désactive l'interface
			return
		for child in vbox_node.get_children(): #on désactive tous les boutons
			child.disabled = true
		GameState.double_remove_call = false #pour ne pas aller la fonction remove_button deux fois
		if GameData.Item[item_name].Type == "Weapon": #si l'objet est un équipement, on met à jour le nom des boutons en fontion
			if GameData.Item[item_name].Equiped == false: #on ne veut pas afficher la description de l'objet quand il est déjà équipé
				Logs._log_item("Description",item_name) #la description des objets est visible dans les logs
				await get_tree().create_timer(0.7).timeout
				Logs._log_item("Statistiques",item_name) #les statistiques de l'arme sont visibles dans les logs
				use_button.text = "Equiper"
			if GameData.Item[item_name].Equiped == true: #si une arme est équipée, alors on souhaite l'enlever avant de la jeter
				throw_button.text = "Enlever"
			else:
				throw_button.text = "Jeter"
		elif GameData.Item[item_name].Type != "Weapon": #dans tous les autres cas, les boutons sont dans un état normal
			Logs._log_item("Description",item_name)
			use_button.text = "Utiliser"
			throw_button.text = "Jeter"
		
		validation_node.visible = true #on fait apparaître le sous menu
		
		#déconnexion des signaux pour corriger Lambda capture at index 0 was freed. Passed "null" instead et être iso avec la logique de l'interface de l'inventaire
		disconnect_all_signal(use_button.pressed)
		disconnect_all_signal(throw_button.pressed)
		disconnect_all_signal(cancel_button.pressed)
		
		use_button.pressed.connect(func():_use_button(item_button,item_name))
		throw_button.pressed.connect(func():_remove_button(item_button,item_name))
		cancel_button.pressed.connect(func():_cancel_button())
		
func disconnect_all_signal(sig: Signal):
	var connections: Array = sig.get_connections()
	for conn in connections:
		sig.disconnect(conn["callable"]) #callable = clé du dico généré
		
func _use_button(item_button,item_name): #note: en principe il suffirait juste d'appeler la fonction _remove_button, mais godot veut pas
	if item_button !=null and GameData.player_current_action_point > 0:  #vérifie si l'item existe
		if GameData.Item[item_name].Type == "Weapon" and GameState.weapon_equipped == true:
			if GameState.weapon_equipped_name == item_name: #Si une arme est équipée, alors on arrête la fonction
				Logs._log_item("Already_Equiped",item_name)
				return
			else:
				Inventory._exchange_item(item_name)
		elif GameData.Item[item_name].Type == "Weapon" and GameState.weapon_equipped == false:
			Inventory._use_item(item_name) #on utilise l'item
		elif GameData.Item[item_name].Type == "Consumable":
			if GameData.player_HP < GameData.player_MAX_HP:
				Inventory._use_item(item_name) #on utilise l'item
				Inventory._remove_item(item_name) #on le retire de l'inventaire
			else:
				Logs._log_item("Cannot_Heal",item_name)
		elif GameData.Item[item_name].Type == "Special":
			Logs._add_log("Tu veux utiliser Kojirō ?")
		item_button = null #par précaution de pas delete un bouton déjà supprimé
		update_inventory(Inventory.inventory)
		validation_node.visible = false #on cache le sous menu
	
func _remove_button(item_button,item_name):
	if item_button !=null and GameData.player_current_action_point > 0: #vérifie si l'item existe
		if GameData.Item[item_name].Type == "Weapon":
			var equipped_label = item_button.get_node("Equipped_Label")
			equipped_label.visible = false
		elif GameData.Item[item_name].Type == "Special":
			Logs._add_log("Kojirō ne veut pas partir...")
		Inventory._remove_item(item_name) #on le retire de l'inventaire
		item_button = null #par précaution de pas delete un bouton déjà supprimé
		validation_node.visible = false #on cache le sous menu
		update_inventory(Inventory.inventory) #au lieu de supprimer le noeud ici, on rappelle la focntion d'update de l'inventaire

func _cancel_button():
	update_inventory(Inventory.inventory) #on update l'inventaire pour réactiver tous les boutons et déconnecter les signaux
	validation_node.visible = false
