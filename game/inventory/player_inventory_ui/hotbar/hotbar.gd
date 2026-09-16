extends Inventory
class_name Hotbar

var current_selected_slot: Slot

func _ready() -> void:
	reload_slots()

func reload_slots() -> void:
	GlobalInventoryAccess.fill_slots(
		inventory_data,
		slot_scene,
		grid_container,
		true
	)

func _process(_delta: float) -> void:
	check_selection_input()

func check_selection_input() -> void:
	for i in range(6):
		var action_name: String = "hotbar_" + str(i)

		if not Input.is_action_just_pressed(action_name): continue
		if current_selected_slot == inventory_data.slots[i]: continue

		if current_selected_slot:
			current_selected_slot.set_selected(false)
			
		current_selected_slot = inventory_data.slots[i]
		current_selected_slot.set_selected(true)


	
