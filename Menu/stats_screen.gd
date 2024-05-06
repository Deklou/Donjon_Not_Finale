extends CanvasLayer

signal to_intro_level

func _ready():
	if GameState.ending_triggered == true:
		$ColorRect/Button.visible = false
		$ColorRect/VBoxContainer3/Label.text = " 1"
		$ColorRect/VBoxContainer3/Label3.text = " " + str(GameData.legendary_weapon_acquired)
		$ColorRect/VBoxContainer3/Label2.text = " " + str(GameData.enemy_defeated)	
		$ColorRect/VBoxContainer3/Label5.text = str(int(GameData.timer) / 3600) + "h " + str((int(GameData.timer) % 3600) / 60) + "min " + str(int(GameData.timer) % 60) + "s" 
		$ColorRect/VBoxContainer2/Label6.text = str(GameData.player_death_count)
		if GameData.secret_triggered == true:
			$ColorRect/VBoxContainer3/Label4.text = " 1"

func _on_button_pressed():
	to_intro_level.emit()
