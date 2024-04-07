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
		var item_label = Label.new()
		item_label.text = item_name
		vbox_node.add_child(item_label)
