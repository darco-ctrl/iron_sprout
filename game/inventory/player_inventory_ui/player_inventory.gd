extends Control
class_name PlayerInventory

@export var hotbar: HotbarUI
@export var backpack: BackpackInventoryUI
@export var drag_manager: DragManager

func _ready() -> void:
	InventoryBuilder.drag_manager = drag_manager

func add_item(slot: SlotData) -> int:
	
	var left_over: int = slot.quantity

	var slots: Array[Slot] = hotbar.slots

	left_over = add_to_inventory(
		slot.item_data,
		left_over,
		slots,)

	if left_over <= 0: return left_over

	#inventory = 
	left_over = add_to_inventory(
		slot.item_data,
		left_over,
		slots,)

	return left_over

func add_to_inventory(item_data: ItemData, quantity: int, slots: Array[Slot]) -> int:
	
	var left_over: int = quantity

	for slot in slots:
		left_over = slot.add_item(item_data, left_over)

		if left_over <= 0: break

	return left_over
