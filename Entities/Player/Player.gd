extends CharacterBody2D

var move_speed : float = 250

func _process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		$AnimationPlayer.play("walk_right")
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		$AnimationPlayer.play("walk_left")
	if Input.is_action_pressed("down"):
		velocity.y += 1
		$AnimationPlayer.play("walk_down")
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		$AnimationPlayer.play("walk_up")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * move_speed
	else:
		$AnimationPlayer.stop()
	
	position += velocity * delta
	move_and_slide()
