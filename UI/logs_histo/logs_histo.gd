extends Node2D

@onready var vbox_node = $UI_logs/HBoxContainer/VBoxContainer

func _ready():
	Logs.add_logs.connect(add_logs)
		
func add_logs(logs:Array):
	if logs.size() > 0:
		var label = preload("res://UI/Logs_Label.tscn").instantiate()
		var color_rect_node = label.get_node("ColorRect_Animation")
		color_rect_node.visible = false
		label.text = logs[0]
		vbox_node.add_child(label, true)
		vbox_node.move_child(label, 0)
