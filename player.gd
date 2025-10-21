extends CharacterBody2D

@export var speed: float = 80.0

var character_direction: Vector2 = Vector2.ZERO
var sitting: bool = false
var last_facing_right: bool = false  # Remember which way we were facing

# Automatically get the furniture TileMap named "furni" in the same scene
@onready var furni: TileMap = get_parent().get_node("furni")

func _physics_process(_delta: float) -> void:
	if sitting:
		velocity = Vector2.ZERO
		return  # no movement while sitting
	
	# Get input
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	# Normalize so diagonal speed stays consistent
	if character_direction.length() > 0:
		character_direction = character_direction.normalized()
	
	# Flip sprite based on direction
	if character_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		last_facing_right = false
	elif character_direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		last_facing_right = true
	
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

func _input(event):
	if event.is_action_pressed("interact"):  # E/space key
		if sitting:
			stand_up()
		else:
			try_sit()

func try_sit():
	# Get player's tile position
	var local_pos = furni.to_local(global_position)
	var player_cell = furni.local_to_map(local_pos)
	
	# Check current tile and adjacent tiles (up, down, left, right)
	var cells_to_check = [
		player_cell,                           # Current tile
		player_cell + Vector2i(0, -1),         # Up
		player_cell + Vector2i(0, 1),          # Down
		player_cell + Vector2i(-1, 0),         # Left
		player_cell + Vector2i(1, 0),          # Right
		player_cell + Vector2i(-1, -1),        # Top-left diagonal
		player_cell + Vector2i(1, -1),         # Top-right diagonal
		player_cell + Vector2i(-1, 1),         # Bottom-left diagonal
		player_cell + Vector2i(1, 1),          # Bottom-right diagonal
	]
	
	for cell in cells_to_check:
		var tile_data = furni.get_cell_tile_data(0, cell)
		
		if tile_data != null:
			# Check if tile has the custom data "interaction"
			if tile_data.get_custom_data("interaction") == "chair":
				sit_down(cell)
				return
	
	print("No chair nearby to sit on!")

func sit_down(cell: Vector2i):
	sitting = true
	
	# Snap player to chair center
	var chair_world_pos = furni.to_global(furni.map_to_local(cell))
	global_position = chair_world_pos + Vector2(0,8.0)
	$AnimatedSprite2D.play("sit")
	
	print("Sitting on chair at tile: ", cell)

func stand_up():
	sitting = false
	
	# Restore the flip direction we had before sitting
	$AnimatedSprite2D.flip_h = last_facing_right
	
	# Play idle animation
	$AnimatedSprite2D.play("idle")
