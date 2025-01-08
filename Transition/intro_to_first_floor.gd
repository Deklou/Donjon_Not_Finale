extends CanvasLayer

func _ready():
	EntitiesState.player_is_frozen = true
	$ColorRect/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(2.8).timeout
	$ColorRect/AnimationPlayer.play("fade_in")
	await get_tree().create_timer(5.0).timeout
	$ColorRect/ColorRect2.visible = false
	EntitiesState.player_is_frozen = false
