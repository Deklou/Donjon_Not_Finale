extends Node2D

signal to_first_floor

func _ready():
	to_first_floor.emit() #vers root
	
