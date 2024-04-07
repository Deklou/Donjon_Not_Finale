extends CharacterBody2D

var currPos
@export var distance = 64 #taille d'une case

#variables pour définir si le joueur peut se déplacer

var can_move_left : bool = true
var can_move_right : bool = true
var can_move_up : bool = true
var can_move_down : bool = true

#la position est décidée dans les scènes respectives

func _ready():
	currPos = $".".position

func _input(event):
	if event.is_action_pressed("right"):
		$AnimationPlayer.play("walk_right")
		if can_move_right:
			currPos.x += distance
			self.position = Vector2(currPos.x,currPos.y)
	elif event.is_action_pressed("left"):
		$AnimationPlayer.play("walk_left")
		if can_move_left:
			currPos.x -= distance
			self.position = Vector2(currPos.x,currPos.y)
	elif event.is_action_pressed("up"):
		$AnimationPlayer.play("walk_up")
		if can_move_up:
			currPos.y -= distance
			$AnimationPlayer.play("walk_up")
			self.position = Vector2(currPos.x,currPos.y)
	elif event.is_action_pressed("down"):
		$AnimationPlayer.play("walk_down")
		if can_move_down:
			currPos.y += distance
			self.position = Vector2(currPos.x,currPos.y)
	#StatsSystem.player_turn_end()

func _on_area_down_body_entered(_body):
	can_move_down = false
func _on_area_down_body_exited(_body):
	can_move_down = true

func _on_area_up_body_entered(_body):
	can_move_up = false
func _on_area_up_body_exited(_body):
	can_move_up = true

func _on_area_left_body_entered(_body):
	can_move_left = false
func _on_area_left_body_exited(_body):
	can_move_left = true

func _on_area_right_body_entered(_body):
	can_move_right = false
func _on_area_right_body_exited(_body):
	can_move_right = true
