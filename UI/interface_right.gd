extends ColorRect

@onready var vbox_node = $ScrollContainer/VBoxContainer #le noeud auquel on souhaite ajouter les objets 


func _ready():
	Inventory.item_added.connect(update_inventory) #dès qu'on ajoute un item dans l'inventaire, on update l'interface

func update_inventory(inventory: Array):
	for child in vbox_node.get_children():
		child.queue_free() # Supprimer tous les enfants du VBoxContainer avant de les recréer
	for item_name in inventory: #Pour chaque objet de l'inventaire, on créé un bouton
		var item_button = Button.new()
		item_button.text = item_name
		vbox_node.add_child(item_button)
