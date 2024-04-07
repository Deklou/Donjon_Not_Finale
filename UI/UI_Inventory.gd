extends ColorRect

@onready var vbox_node = $UI_Inventory/VBoxContainer #le noeud auquel on souhaite ajouter les objets 
@onready var validation_node = $Validation_menu/MarginContainer/Validation #le noeud sur lequel se trouve le menu de validation

@onready var use_button = $Validation_menu/MarginContainer/Validation/Use_button
@onready var throw_button = $Validation_menu/MarginContainer/Validation/Throw_button
@onready var cancel_button = $Validation_menu/MarginContainer/Validation/Cancel_button


func _ready():
	Inventory.item_added.connect(update_inventory) #dès qu'on ajoute un item dans l'inventaire, on update l'interface
	if Inventory.inventory.size() == 0 : #Si l'inventaire est vide, on ne peut accéder au sous menu
		validation_node.visible = false

func update_inventory(inventory: Array):
	for child in vbox_node.get_children():
		child.queue_free() # Supprimer tous les enfants du VBoxContainer avant de les recréer
	for item_name in inventory: #Pour chaque objet de l'inventaire, on créé un bouton
		var item_button = Button.new()
		item_button.text = item_name
		item_button.name = item_name #pour debug plus facilement
		vbox_node.add_child(item_button)
		item_button.pressed.connect(func():validation_menu(item_button, item_name)) #si on sélectionne l'objet

func validation_menu(item_button, item_name):
	if GameState.is_ennemy_turn == false:
		if GameState.Ui_Inventory_is_locked == true : #Si le flag est vrai, on désactive l'interface
			return
		for child in vbox_node.get_children(): #on désactive tous les boutons
			child.disabled = true
		GameState.double_remove_call = false #pour ne pas aller la fonction remove_button deux fois
		if GameData.Item[item_name].Type == "Weapon": #si l'objet est un équipement, on met à jour le nom des boutons en fontion
			if GameData.Item[item_name].Equiped == false: #on ne veut pas afficher la description de l'objet quand il est déjà équipé
				Logs._log_item("Description",item_name) #la description des objets est visible dans les logs
			use_button.text = "Equiper"
			if GameData.Item[item_name].Equiped == true: #si une arme est équipée, alors on souhaite l'enlever avant de la jeter
				throw_button.text = "Enlever"
			else:
				throw_button.text = "Jeter"
		else: #dans tous les autres cas, les boutons sont dans un état normal
			use_button.text = "Utiliser"
			throw_button.text = "Jeter"
		
		validation_node.visible = true #on fait apparaître le sous menu
	
		use_button.pressed.connect(func():_use_button(item_button,item_name))
		throw_button.pressed.connect(func():_remove_button(item_button,item_name))
		cancel_button.pressed.connect(func():_cancel_button())
		
func _use_button(item_button,item_name): #note: en principe il suffirait juste d'appeler la fonction _remove_button, mais godot veut pas
	if item_button !=null:  #vérifie si l'item existe
		if GameData.Item[item_name].Type == "Weapon" and GameState.weapon_equipped == true: #Si une arme est équipée, alors on arrête la fonction
			Logs._log_item("Already_Equiped",item_name)
			return
		if GameData.Item[item_name].Type == "Item":
			Inventory._use_item(item_name) #on utilise l'item
			Inventory._remove_item(item_name) #on le retire de l'inventaire
			update_inventory(Inventory.inventory) #au lieu de supprimer le noeud ici, on rappelle la focntion d'update de l'inventaire
		elif GameData.Item[item_name].Type == "Weapon":
			Inventory._use_item(item_name)
		item_button = null #par précaution de pas delete un bouton déjà supprimé
		update_inventory(Inventory.inventory)
		validation_node.visible = false #on cache le sous menu
	
func _remove_button(item_button,item_name):
	if item_button !=null: #vérifie si l'item existe
		Inventory._remove_item(item_name) #on le retire de l'inventaire
		item_button = null #par précaution de pas delete un bouton déjà supprimé
		validation_node.visible = false #on cache le sous menu
		update_inventory(Inventory.inventory) #au lieu de supprimer le noeud ici, on rappelle la focntion d'update de l'inventaire

func _cancel_button():
	update_inventory(Inventory.inventory) #on update l'inventaire pour réactiver tous les boutons et déconnecter les signaux
	validation_node.visible = false
