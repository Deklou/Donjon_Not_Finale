extends Node2D

signal to_level_1

func _on_to_level_1_area_body_entered(_body): #voyager vers le niveau 1
	#get_tree().change_scene_to_file("res://Levels/Level 1/level_1.tscn")
	to_level_1.emit()
