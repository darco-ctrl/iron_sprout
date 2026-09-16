extends CharacterBody3D
class_name  Player

#---- EXPORT NODES ----#
@export var headpivot: Node3D
@export var camera: Camera3D

#---- EXPORT RESOURCES ----#
@export var player_inventory_man: PlayerInventory
@export var player_hunger: PlayerHunger

#---- RESOURCES ----#
var player_hotbar: Hotbar

#---- EXPORT VALUES ----#
@export var max_speed: float = 5
@export var jump_velocity: float = 6.5
@export var gravity: float = 20.0

@export_range(0, 1, 0.0001) var camera_sensitivity: float = 0.0005

#---- VALUES ----#
var mouse_locked: bool = false
var is_player_running: bool = false
var player_velocity: Vector3 = Vector3.ZERO
var head_transform: Basis

func _ready() -> void:
	player_inventory_man.player = self
	player_hotbar = player_inventory_man.get_inventory("hotbar")

func _physics_process(_delta: float) -> void:
	movement(_delta)
	handle_input()

func _input(event: InputEvent) -> void:
	if mouse_locked && event is InputEventMouseMotion:
		rotate_head(event)

func handle_input() -> void:
	if Input.is_action_just_pressed("lock_mouse"):
		mouse_locked = !mouse_locked
		if mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func rotate_head(mouse_event: InputEventMouseMotion):
	headpivot.rotate_y(-mouse_event.relative.x * camera_sensitivity)
	camera.rotate_x(-mouse_event.relative.y * camera_sensitivity)

func movement(delta_time: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	player_velocity = velocity
	player_velocity.y = 0

	if !is_on_floor():
		velocity.y -= gravity * delta_time

	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_pressed("move_forward"): direction.z -= 1
	if Input.is_action_pressed("move_backward"): direction.z += 1
	if Input.is_action_pressed("move_left"): direction.x -= 1
	if Input.is_action_pressed("move_right"): direction.x += 1

	direction = (headpivot.transform.basis * direction).normalized()
	player_velocity = direction * max_speed
	velocity = Vector3(player_velocity.x, velocity.y, player_velocity.z)

	move_and_slide()

func get_selected_slot() -> Slot:
	if !player_hotbar:
		return

	var slot: Slot = player_hotbar.current_selected_slot

	return slot
