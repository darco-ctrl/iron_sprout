extends Control
class_name PlayerInventory

@export var inventories: Array[Inventory]
@export var drag_manager: DragManager

var player: Player

func _ready() -> void:
	GlobalInventoryAccess.player_inventory = self
	GlobalInventoryAccess.drag_manager = drag_manager
	drag_manager.player = player

func get_inventory(id: String) -> Inventory:
	for inventory in inventories:
		if inventory.inventory_data.id == id:
			return inventory

	print("no inventory available")
	return null

func add_item(slot: SlotData) -> int:

	var left_over: int = slot.quantity
	var slots: Array[Slot] = get_all_slots()

	left_over = add_to_inventory(
		slot.item_data,
		left_over,
		slots,)

	return left_over

func remove_item(item: ItemData, quantity) -> void:

	for slot in get_all_slots():
		var slot_data = slot.slot_data
		if not slot_data.item_data: continue
		if slot_data.item_data.id != item.id: continue
		if slot_data.quantity < quantity: continue

		slot_data.quantity -= quantity
		slot.update_slot()

func has_item(item: ItemData, quantity: int) -> bool:

	for slot in get_all_slots():
		var slot_data = slot.slot_data
		if not slot_data.item_data: continue
		if slot_data.item_data.id != item.id: continue
		if slot_data.quantity < quantity: continue

		return true

	return false

func has_tag(tag: String) -> Slot:

	for slot in get_all_slots():
		var slot_data = slot.slot_data
		if not slot_data.item_data: continue

		var tool_data = slot_data.item_data as ToolData
		if not tool_data: continue
		if tool_data.tool_tag == tag: return slot

	return null

func add_to_inventory(item_data: ItemData, quantity: int, slots: Array[Slot]) -> int:

	var left_over: int = quantity

	# try in occupied
	for slot in slots:
		if not slot.slot_data.item_data: continue
		left_over = slot.add_item(item_data, left_over)

		if left_over <= 0: break

	# check for empty
	for slot in slots:
		if slot.slot_data.item_data: continue
		left_over = slot.add_item(item_data, left_over)

		if left_over <= 0: break

	return left_over

func get_all_slots() -> Array[Slot]:
	var all_slots: Array[Slot] = []

	for inventory in inventories:
		all_slots.append_array(inventory.inventory_data.slots)

	return all_slots
