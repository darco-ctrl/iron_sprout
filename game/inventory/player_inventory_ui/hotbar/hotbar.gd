extends Control

class_name HotbarUI

@export var slot_grid: HBoxContainer

@export var slot_packed_scene: PackedScene
@export var max_slots: int = 6

var slots: Array[Slot]

func _ready() -> void:
	reload_slots()

func reload_slots() -> void:
	
	InventoryBuilder.give_slot(
		slots,
		slot_packed_scene,
		slot_grid,
		max_slots
	)
	
