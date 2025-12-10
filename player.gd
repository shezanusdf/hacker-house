extends CharacterBody2D

@export var speed: float = 80.0

var character_direction: Vector2 = Vector2.ZERO
var sitting: bool = false
var last_facing_right: bool = false  # Remember which way we were facing
var anim_state: String = "idle"
var is_sitting: bool = false


# Automatically get the furniture TileMap named "furni" in the same scene
@onready var furni: TileMap = get_parent().get_node("furni")

func _physics_process(delta):
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
	var new_anim = "idle"
	if sitting:
		new_anim = "sit"
	elif character_direction != Vector2.ZERO:
		new_anim = "walking"
	
	if new_anim != anim_state or sitting != is_sitting:
		anim_state = new_anim
		is_sitting = sitting
		$AnimatedSprite2D.play(anim_state)
	
	if character_direction != Vector2.ZERO:
		velocity = character_direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()


func _input(event):
	if event.is_action_pressed("interact"):
		if sitting:
			stand_up()
		else:
			try_sit()

func try_sit():
	var local_pos = furni.to_local(global_position)
	var player_cell = furni.local_to_map(local_pos)
	
	var cells_to_check = [
		player_cell,
		player_cell + Vector2i(0, -1),
		player_cell + Vector2i(0, 1),
		player_cell + Vector2i(-1, 0),
		player_cell + Vector2i(1, 0),
		player_cell + Vector2i(-1, -1),
		player_cell + Vector2i(1, -1),
		player_cell + Vector2i(-1, 1),
		player_cell + Vector2i(1, 1),
	]
	
	for cell in cells_to_check:
		var tile_data = furni.get_cell_tile_data(0, cell)
		if tile_data != null and tile_data.get_custom_data("interaction") == "chair":
			sit_down(cell)
			return
	
	print("No chair nearby to sit on!")

func sit_down(cell: Vector2i):
	sitting = true
	var chair_world_pos = furni.to_global(furni.map_to_local(cell))
	global_position = chair_world_pos + Vector2(0,8.0)
	$AnimatedSprite2D.play("sit")
	print("Sitting on chair at tile: ", cell)

func stand_up():
	sitting = false
	$AnimatedSprite2D.flip_h = last_facing_right
	$AnimatedSprite2D.play("idle")


func update_animation(new_anim: String, sitting_state: bool, facing_right: bool):
	anim_state = new_anim
	is_sitting = sitting_state
	last_facing_right = facing_right
	$AnimatedSprite2D.flip_h = last_facing_right
	$AnimatedSprite2D.play(anim_state)
