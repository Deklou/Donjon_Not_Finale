extends Node2D

signal to_the_end
signal to_secret

var event : bool = true

func _on_end_body_entered(_body):
	to_the_end.emit()

func _process(_delta):
	if GameData.all_objective_completed == true and event == true:
		$Sprite2D.position = Vector2(32,32)
		Logs._add_log("De l'autre côté...")
		event = false

func _on_secret_body_entered(_ddbody):
	if GameData.all_objective_completed == true:
		to_secret.emit()
