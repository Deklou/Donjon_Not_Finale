extends Control

func _on_restart_button_pressed():
	GameState.restart_game()
	
func _on_quit_button_pressed():
	get_tree().quit()
