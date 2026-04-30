extends Control
class_name PlayerInventory

@export var hotbar: HotbarUI
@export var drag_manager: DragManager

var player: Player

func _ready() -> void:
	GlobalInventoryAccess.player_inventory = self
	GlobalInventoryAccess.drag_manager = drag_manager
	drag_manager.player = player

func add_item(slot: SlotData) -> int:
	
	var left_over: int = slot.quantity

	var slots: Array[Slot] = hotbar.slots

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
