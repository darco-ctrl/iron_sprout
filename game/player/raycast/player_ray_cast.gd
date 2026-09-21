extends RayCast3D

@export var player: Player

var hover_object: ObjectBehavior = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	handle_input()
	check_collision()

func handle_input():
	if Input.is_action_just_pressed("attack"):
		attack_object()

func check_collision():
	if !is_colliding_object():
		clear_hover_object()

func is_colliding_object() -> bool:
	if !is_colliding():
		return false

	var collider = get_collider() as Node3D
	if !collider:
		return false

	var object = collider.get_parent() as ObjectBehavior
	if !object: return false

	set_hover_object(object)
	return true

func attack_object():
	if !hover_object: return

	var current_tool = player.get_current_tool()
	if !current_tool: return

	hover_object.on_hit(current_tool)

func clear_hover_object():
	if !hover_object: return

	hover_object.on_hover_exit()
	hover_object = null

func set_hover_object(object: ObjectBehavior):
	if hover_object && hover_object == object: return

	if hover_object:
		hover_object.on_hover_exit()

	hover_object = object
	hover_object.on_hover_enter()
