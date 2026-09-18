extends CharacterBody3D
class_name  Player

#---- NODE REFERENCES ----#
@export var head_pivot: Node3D
@export var camera: Camera3D
@export var item_drop_origin: Node3D

#---- RESOURCE REFERENCES ----#
@export var player_inventory_manager: PlayerInventory
@export var player_hunger: PlayerHunger

var player_hotbar: Hotbar


#---- PLAYER MOVEMENT ----#
const SPRINT_SPEED: float = 6
const WALK_SPEED: float = 4.6
var jump_velocity: float = 4.5
var gravity: float = 9.8
var player_speed: float = 0
var player_velocity: Vector3 = Vector3.ZERO
var is_player_running: bool = false

#---- CAMERA SETTINGS ----#
@export_range(0, 1, 0.0001)
var camera_sensitivity: float = 0.0005


#---- CAMERA STATE ----#
const BASE_FOV: float = 75.0
const FAV_CHANGE: float = 1.5
const BOB_FREQUENCY: float = 2.0
const BOB_AMPLITUDE: float = 0.08
var mouse_locked: bool = false
var head_transform: Basis
var time_bob: float = 0.0


func _ready() -> void:
	player_inventory_manager.player = self
	player_hotbar = player_inventory_manager.get_inventory("hotbar")

func _physics_process(delta: float) -> void:
	movement(delta)
	handle_input()
	head_bob(delta)

func _input(event: InputEvent) -> void:
	if mouse_locked && event is InputEventMouseMotion:
		rotate_head(event)

func rotate_head(mouse_event: InputEventMouseMotion):
	head_pivot.rotate_y(-mouse_event.relative.x * camera_sensitivity)
	camera.rotate_x(-mouse_event.relative.y * camera_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func head_bob(delta_time: float):
	time_bob += delta_time * velocity.length() * float(is_on_floor())

	camera.transform.origin = get_head_bob_pos(time_bob)

func get_head_bob_pos(time: float) -> Vector3:
	var pos: Vector3 = Vector3.ZERO

	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE

	return pos

func movement(delta_time: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta_time

	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_pressed("sprint"):
		player_speed = SPRINT_SPEED
	else:
		player_speed = WALK_SPEED

	var direction: Vector3 = get_player_input_direction()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * player_speed
			velocity.z = direction.z * player_speed

		else:
			velocity.x = lerp(velocity.x, direction.x * player_speed, delta_time * 7.0)
			velocity.z = lerp(velocity.z, direction.z * player_speed, delta_time * 7.0)

	else:
		velocity.x = lerp(velocity.x, direction.x * player_speed, delta_time * 3.0)
		velocity.z = lerp(velocity.z, direction.z * player_speed, delta_time * 3.0)

	change_camera_fov(delta_time)

	move_and_slide()

func change_camera_fov(delta_time: float):
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FAV_CHANGE * velocity_clamped

	camera.fov = lerp(camera.fov, target_fov, delta_time * 8.0)

func get_player_input_direction() -> Vector3:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


	var direction: Vector3 = (
		head_pivot.transform.basis * Vector3(
			input.x, 0, input.y
	)).normalized()
	return direction

func get_selected_slot() -> Slot:
	if !player_hotbar:
		return

	var slot: Slot = player_hotbar.current_selected_slot

	return slot


func handle_input() -> void:
	if Input.is_action_just_pressed("lock_mouse"):
		mouse_locked = !mouse_locked
		if mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func get_current_tool() -> ToolData:
	var slot = get_selected_slot()
	if !slot: return null

	var tool_data = slot.get_item_data()
	if !tool_data: return null

	return tool_data

func get_facing_direction() -> Vector3:
	return -camera.global_transform.basis.z


func get_drop_origin() -> Vector3:
	return item_drop_origin.global_position
