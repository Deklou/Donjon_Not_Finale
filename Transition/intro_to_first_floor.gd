extends CanvasLayer

func _ready():
	$ColorRect/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(2.8).timeout
	$ColorRect/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(10.0).timeout
	$ColorRect/ColorRect2.visible = false
