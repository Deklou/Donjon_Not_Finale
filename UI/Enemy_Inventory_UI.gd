extends Control

@onready var vbox_node : VBoxContainer = $ScrollContainer/VBoxContainer

func _ready():
	Inventory.update_enemy_inventory_UI.connect(update_enemy_inventory)
	EntitiesState.ennemy_inventory_UI.connect(show_enemy_inventory)
	StatsSystem.hide_inventory_UI.connect(hide_enemy_inventory)

func show_enemy_inventory():
	$".".visible = true
	
func hide_enemy_inventory():
	$".".visible = false

func update_enemy_inventory(inventory: Array):
	for child in vbox_node.get_children():
		child.queue_free()
	for item_name in inventory:
		var item_label = preload("res://UI/Inventory_Enemy_Item.tscn").instantiate()
		var item_icon = item_label.get_node("Icon")
		if not item_name.is_empty(): #Pour éviter de définir le nom d'un noeud vide. 
			item_label.text = item_name
			item_label.name = item_name
			vbox_node.add_child(item_label)
			if GameData.Item[item_name].Type == "Weapon":
				item_icon.texture = preload("res://Sprites/UI_icon/weapon.png")
				var equipped_label = item_label.get_node("Equipped_Label")
				equipped_label.visible = true
			else:
				item_icon.texture = preload("res://Sprites/UI_icon/consumable.png")
