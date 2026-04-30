extends ObjectBehavior
class_name HarvestableBehavior

var health: float

@export var sprite_3d: Sprite3D
@export var selection_indiecator_mesh: MeshInstance3D

func _ready() -> void:
	selection_indiecator_mesh.visible = false
	health = object_data.max_health

func on_hit(tool_data: ToolData) -> void:
	print("BF Object Health = " + str(health))
	health -= tool_data.action_power / object_data.hardness

	print("AF Object Health = " + str(health))
	if health <= 0:
		deystroy_object()
		
func deystroy_object() -> void:
	var slots_data: Array[SlotData] = get_object_drop()
	var spawn_pos: Vector3 = position
	spawn_pos.y = 0.2
	for slot_data in slots_data:
		GlobalInventoryAccess.drop_manager.drop_item_at_location(
			slot_data, spawn_pos
		)
	queue_free()

func on_hover_enter() -> void:
	selection_indiecator_mesh.visible = true

func on_hover_exit() -> void:
	selection_indiecator_mesh.visible = false

func get_object_drop() -> Array[SlotData]:
	var slots_data: Array[SlotData]

	var slot_data: SlotData = SlotData.new()
	slot_data.item_data = object_data.drop_item
	slot_data.quantity = 6

	slots_data.append(slot_data)

	return slots_data
