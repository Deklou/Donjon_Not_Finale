extends Node2D


func _on_to_level_0_area_body_entered(_body): #voyager vers le niveau 0
	get_tree().change_scene_to_file("res://Levels/Level 0/Level_0.tscn")
