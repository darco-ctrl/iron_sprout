extends Control
class_name PlayerInventory

@export var hotbar: HotbarUI
@export var backpack: BackpackInventoryUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_item(slot: SlotData) -> int:
	
	var left_over: int = slot.quantity

	var inventory: Inventory = hotbar.Inventory

	left_over = add_to_inventory(
		slot.item_data,
		left_over,
		inventory.slots,
		inventory.max_slots)

	if left_over <= 0: return left_over

	inventory = backpack.Inventory
	left_over = add_to_inventory(
		slot.item_data,
		left_over,
		inventory.slots,
		inventory.max_slots)

	return left_over

func add_to_inventory(item_data: ItemData, quantity: int, slots: Array[SlotData], slots_max: int) -> int:
	
	var left_over: int = 0

	for i in range(slots_max):
		left_over = slots[i].add_item(item_data, quantity)

		if left_over <= 0: break

	return left_over
