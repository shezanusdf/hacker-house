extends CharacterBody2D

@export var speed: float = 80.0
var character_direction: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Get input
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")

	# Normalize so diagonal speed stays consistent
	if character_direction.length() > 0:
		character_direction = character_direction.normalized()

	# Flip sprite based on direction
	if character_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif character_direction.x < 0:
		$AnimatedSprite2D.flip_h = true

	# Move and animate
	if character_direction != Vector2.ZERO:
		velocity = character_direction * speed
		if $AnimatedSprite2D.animation != "walking":
			$AnimatedSprite2D.play("walking")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")

	move_and_slide()
