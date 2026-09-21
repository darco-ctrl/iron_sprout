extends ObjectBehavior
class_name HarvestableBehavior

@export var model: HarvestableModel
var health: float

func _ready() -> void:
	health = object_data.max_health

	if object_data.mesh:
		model.set_mesh(object_data.mesh)

func on_hover_enter() -> void:
	model.on_hover_enter()

func on_hover_exit() -> void:
	model.on_hover_exit()

func on_hit(tool_data: ToolData) -> void:
	health -= tool_data.action_power / object_data.hardness
	tool_data.durabiltiy -= 1

	print("tool health = " + str(tool_data.durabiltiy))
	if health <= 0:
		deystroy_object()

func deystroy_object() -> void:
	var slots_data: Array[SlotData] = get_object_drop()
	var item_drop_position: Vector3 = global_position
	item_drop_position.y = 0.2
	for slot_data in slots_data:
		GlobalInventoryAccess.drop_manager.drop_item_at_location(
			slot_data, item_drop_position
		)
	queue_free()

func get_object_drop() -> Array[SlotData]:
	var slots_data: Array[SlotData]

	var slot_data: SlotData = SlotData.new()
	slot_data.item_data = object_data.drop_item
	slot_data.quantity = 6

	slots_data.append(slot_data)

	return slots_data
