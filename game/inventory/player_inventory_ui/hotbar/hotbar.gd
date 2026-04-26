extends Control

class_name HotbarUI

@export var slot_grid: HBoxContainer

@export var inventory: Inventory
@export var slot_packed_scene: PackedScene

func _ready() -> void:
	reload_slots()

func reload_slots() -> void:
	
	for i in range(inventory.max_slots):
		
		var slot: Slot = slot_packed_scene.instantiate()
		slot.name = "hotbar_" + str(i)

		slot_grid.add_child(slot)


	
