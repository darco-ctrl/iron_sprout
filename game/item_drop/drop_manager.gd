extends Node3D
class_name  DropManager

@export var item_drop_scene: PackedScene

@export var player: Player 

@export var item_data: ItemData

func _ready() -> void:
	GlobalInventoryAccess.drag_manager.drop_manager = self
	GlobalInventoryAccess.drop_manager = self

	test_spawn()

func test_spawn() -> void:
	var slot_data: SlotData = SlotData.new()

	slot_data.item_data = item_data
	slot_data.quantity = 1

	var item_drop: ItemDrop = item_drop_scene.instantiate()
	item_drop.slot_data = slot_data

	var pos: Vector3 = Vector3(-1.3, 0.2, -2)

	item_drop.position = pos
	item_drop.update()
	add_child(item_drop)

func drop_item_at_location(slot_data: SlotData, pos: Vector3) -> void:
	var item_drop: ItemDrop = make_item_drop(slot_data)

	drop_item_at(item_drop, pos)
	

func drop_item(slot_data: SlotData) -> void:

	var item_drop: ItemDrop = make_item_drop(slot_data)

	# dropped item positon
	var spawn_pos: Vector3 = player.get_3d_mouse_position()
	spawn_pos.y += 0.1 + (item_drop.item_icon.texture.get_height() *
						  item_drop.item_icon.pixel_size)

	drop_item_at(item_drop, spawn_pos)

func drop_item_at(item_drop: ItemDrop, pos: Vector3) -> void:
	item_drop.position = pos

func make_item_drop(slot_data: SlotData) -> ItemDrop:
	var item_drop: ItemDrop = item_drop_scene.instantiate()
	
	var drop_slot_data: SlotData = SlotData.new()
	drop_slot_data.quantity = slot_data.quantity

	var drop_item_data: ItemData = slot_data.item_data.duplicate()

	drop_slot_data.item_data = drop_item_data

	item_drop.slot_data = drop_slot_data

	slot_data.item_data = null
	slot_data.quantity = 0
	
	add_child(item_drop)  # _ready() runs here, item_icon gets initialized
	item_drop.update()    # now texture exists
	
	return item_drop
