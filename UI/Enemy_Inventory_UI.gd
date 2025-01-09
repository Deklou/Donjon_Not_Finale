extends Control

@onready var vbox_node : VBoxContainer = $ScrollContainer/VBoxContainer
var enemy_inventory_id : String #identifiant de l'interface, le même que l'ennemi dont elel est associée

func _ready():
	enemy_inventory_id = EntitiesState.enemy_id
	Inventory.update_enemy_inventory_UI.connect(update_enemy_inventory)
	EntitiesState.show_enemy_inventory_UI.connect(show_enemy_inventory)
	EntitiesState.hide_enemy_inventory_UI.connect(hide_enemy_inventory)

func show_enemy_inventory():
	if enemy_inventory_id == EntitiesState.selected_id:
		$".".visible = true
	else:
		$".".visible = false
	
func hide_enemy_inventory():
	if enemy_inventory_id == EntitiesState.selected_id:
		$".".visible = false

func update_enemy_inventory(inventory: Array):
	for child in vbox_node.get_children():
		child.visible = false
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
