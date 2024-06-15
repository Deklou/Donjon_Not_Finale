extends Node2D

func _ready():
	GameState.tutorial_end.emit() #vers user_interface
	EntitiesState.enable_player_camera.emit() #vers script joueur

