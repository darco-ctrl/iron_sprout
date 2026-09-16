class_name GlobalInventoryAccess
extends RefCounted

static var drag_manager: DragManager
static var player_inventory: PlayerInventory
static var drop_manager: DropManager

static func fill_slots(
	inventory_data: InventoryData,
	slot_packed_scene: PackedScene,
	grid_container: Control,
	selectable: bool) -> void:

	if inventory_data.slots.size() <= 0:
		for slot in inventory_data.slots:
			slot.queue_free()
		
	inventory_data.slots.resize(inventory_data.max_slots)
	for i in range(inventory_data.max_slots):
		
		var slot: Slot = slot_packed_scene.instantiate()
		slot.name = "slot_" + str(i)
		grid_container.add_child(slot)

		slot.create_slot_data()
		slot.set_selectable(selectable)
		inventory_data.slots[i] = slot
		
