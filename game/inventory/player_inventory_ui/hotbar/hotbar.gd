extends Control

class_name HotbarUI

@export var slot_grid: HBoxContainer


@export var slot_packed_scene: PackedScene
@export var max_slots: int = 6

var slots: Array[Slot]
var current_selected_slot: Slot

func _ready() -> void:
	reload_slots()

func _process(_delta: float) -> void:
	check_selection_input()

func check_selection_input() -> void:
	for i in range(6):
		var action_name: String = "hotbar_" + str(i)

		if not Input.is_action_just_pressed(action_name): continue
		if current_selected_slot:
			current_selected_slot.select_indicator.visible = false
			current_selected_slot = slots[i]
			current_selected_slot.select_indicator.visible = true
		else:
			current_selected_slot = slots[i]
			current_selected_slot.select_indicator.visible = true
			

func reload_slots() -> void:
	
	GlobalInventoryAccess.give_slot(
		slots,
		slot_packed_scene,
		slot_grid,
		max_slots
	)
	
