extends CharacterBody3D
class_name  Player

@export var animation_sprite_3d: AnimatedSprite3D
@export var camera: Camera3D

@export var walk_speed: float = 1.3
@export var run_speed: float = 2

@export var inventory: PlayerInventory


var is_player_running: bool = false

func _ready() -> void:
	inventory.player = self

func _physics_process(_delta: float) -> void:
	movement()
	animate()

func movement() -> void:

	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var speed: float = 0

	if Input.is_action_pressed("sprint"):
		speed = run_speed
		is_player_running = true

	else:
		speed = walk_speed
		is_player_running = false

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()


func animate() -> void:
	
	
	var player_movement: String = "walk"

	if is_player_running:
		player_movement = "run"

	if velocity.x < 0:
		animation_sprite_3d.flip_h = true
	elif 0 < velocity.x:
		animation_sprite_3d.flip_h = false

	

	if velocity.length() < 0.1: # Idle
		animation_sprite_3d.play("idle")

		return
	else: 
		animation_sprite_3d.play(player_movement)

func get_3d_mouse_position() -> Vector3:
	var ray_origin = camera.project_ray_origin(get_viewport().get_mouse_position())
	var ray_dir = camera.project_ray_normal(get_viewport().get_mouse_position())

	if abs(ray_dir.y) < 0.001:  # safety check
		return Vector3.ZERO

	var t = -ray_origin.y / ray_dir.y
	return ray_origin + ray_dir * t

func get_selected_slot_data() -> Slot:
	var slot: Slot = inventory.hotbar.current_selected_slot

	return slot
