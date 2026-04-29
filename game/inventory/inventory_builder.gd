class_name InventoryBuilder
extends RefCounted

static var drag_manager: DragManager	

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

		slot_data.slot_changed.connect(slot.update_slot)

		slot.slot_data = slot_data
		slots[i] = slot
		
