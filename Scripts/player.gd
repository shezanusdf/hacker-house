extends CharacterBody2D

var speed = 200 # pixels per second

func _physics_process(delta):
	var velocity = Vector2.ZERO # The player's movement velocity

	# Get the input and set the velocity
	if Input.is_action_pressed("walk_right"):
		velocity.x += 1
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1
	if Input.is_action_pressed("walk_down"):
		velocity.y += 1
	if Input.is_action_pressed("walk_up"):
		velocity.y -= 1

	# Normalize velocity and apply speed
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

		# Play the correct animation based on the velocity direction
		if velocity.x > 0:
			$AnimatedSprite2D.play("walk_right")
		elif velocity.x < 0:
			$AnimatedSprite2D.play("walk_left")
		elif velocity.y > 0:
			$AnimatedSprite2D.play("walk_down")
		elif velocity.y < 0:
			$AnimatedSprite2D.play("walk_up")
	else:
		$AnimatedSprite2D.stop() # Stop animation when not moving

	# Move the character
	move_and_slide()
