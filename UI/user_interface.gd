extends CanvasLayer

@onready var interface_left_node : ColorRect = $MarginContainer_left/white_bg_left/interface_left
@onready var logs_histo_button : Button = $MarginContainer_left/white_bg_left/interface_left/histo_logs_button
@onready var histo_is_open : bool = false

func _ready():
	EntitiesState.hide_UI.connect(hide_UI)
	Logs.remove_logs.connect(show_button)
	var logs_histo_scene = preload("res://UI/logs_histo/logs_histo.tscn").instantiate()
	logs_histo_scene.visible = false
	interface_left_node.add_child(logs_histo_scene, true)

func hide_UI():
	$".".visible = false

func show_UI():
	$".".visible = true

func show_button():
	logs_histo_button.visible = true

func _on_histo_logs_button_pressed():
	if histo_is_open == false:
		logs_histo_button.text = "Retour"
		interface_left_node.get_child(1).visible = false
		interface_left_node.get_child(4).visible = true
		histo_is_open = true
	else:
		logs_histo_button.text = "Historique"
		interface_left_node.get_child(1).visible = true
		interface_left_node.get_child(4).visible = false
		histo_is_open = false
