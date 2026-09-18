extends RayCast3D

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	handle_input()

func handle_input():
	if Input.is_action_just_pressed("attack"):
		check_collision(false)

func check_collision(is_interaction: bool):
	if !is_colliding(): return

	var current_tool = player.get_current_tool()
	if !current_tool: return

	var collider = get_collider() as Node3D
	if !collider:
		return

	var object = collider.get_parent() as ObjectBehavior
	if !object: return
	print("acction pressed")

	if is_interaction:
		pass
	else:
		handle_attack(object, current_tool)

func handle_attack(object: ObjectBehavior, tooL: ToolData):
	object.on_hit(tooL)
