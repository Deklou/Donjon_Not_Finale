extends Node2D

@onready var Cursor_AnimationPlayer_Roll : AnimationPlayer = $Cursor_AnimationPlayer_Roll

func _ready():
	Cursor_AnimationPlayer_Roll.play("roll")
