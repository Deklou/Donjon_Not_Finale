extends Node2D

signal to_first_floor

var event_1alreay_triggered : bool = false

func _on_event_1_body_entered(_body):
	if event_1alreay_triggered == false:
		$dummy_7.position = Vector2(352,160)
		$Chest9.position = Vector2(32,160)
		Logs._add_log("Vous sentez une\nprésence silencieuse")
		event_1alreay_triggered = true

func _on_event_2_body_entered(_body):
	to_first_floor.emit()
