extends Node3D

@export var harvestables_parent: Node3D

var camera: Camera3D
var player: Player

var current_hover_object: ObjectBehavior

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	player = camera.owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_collision()
	input_check()

func input_check() -> void:
	if not current_hover_object: return

	var current_slot: Slot = player.get_selected_slot()
	if not current_slot: return

	var current_slot_data: SlotData = current_slot.slot_data
	if not current_slot_data: return

	var tool_data: ToolData = current_slot_data.item_data as ToolData
	if not tool_data: return

	if Input.is_action_just_pressed("attack"):

		if (current_hover_object.object_data.requaired_item_tag ==
			tool_data.tool_tag):
			current_hover_object.on_hit(tool_data)
			current_slot.update_slot()

func check_collision() -> void:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()

	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 200

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collision_mask = 4 + 8 + 16
	
	var result = space_state.intersect_ray(query)

	var object_hit = null

	if result:
		object_hit = result.collider.owner as ObjectBehavior

	# hit an object
	if object_hit:
		if current_hover_object != object_hit: # the new object is not same as old one
			if current_hover_object: # if current_hover_object has an object
				current_hover_object.on_hover_exit()

			object_hit.on_hover_enter()
			current_hover_object = object_hit
	else:
		if current_hover_object:
			current_hover_object.on_hover_exit()
			current_hover_object = null
	
