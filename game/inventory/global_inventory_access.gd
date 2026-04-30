class_name GlobalInventoryAccess
extends RefCounted

static var drag_manager: DragManager	
static var player_inventory: PlayerInventory
static var drop_manager: DropManager

static func give_slot(
	slots: Array[Slot],
	slot_packed_scene: PackedScene,
	grid_container: Control,
	slots_size: int) -> void:
	
	slots.resize(slots_size)
	for i in range(slots_size):
		
		var slot: Slot = slot_packed_scene.instantiate()
		slot.name = "slot_" + str(i)
		grid_container.add_child(slot)

		var slot_data = SlotData.new()

		slot.slot_data = slot_data
		slots[i] = slot
		
