extends ScrollContainer

@onready var vbox_node = $VBoxContainer

func _ready():
	Logs.update_logs.connect(update_logs)
	
func update_logs(logs:Array): #se comporte de la même manière que l'interface d'objet
	for child in vbox_node.get_children(): #on supprimer tous les enfants et on les recrée en fonction de ce qu'il y a dans le tableau logs
		child.queue_free()
	for entry in logs:
		var label = Label.new()
		label.text = entry
		vbox_node.add_child(label)
