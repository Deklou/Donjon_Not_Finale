extends CanvasLayer

@onready var back_button : Button = $Back_Button

func _on_back_button_pressed():
	queue_free()
