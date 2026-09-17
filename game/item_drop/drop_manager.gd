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

func drop_item_at_location(slot_data: SlotData, _position: Vector3) -> void:
	var item_drop: ItemDrop = make_item_drop(slot_data)

	var spawn_position = _position
	spawn_position.y += 0.5

	item_drop.position = spawn_position

func drop_from_player(item_slot: SlotData) -> void:
	var item_drop: ItemDrop = make_item_drop(item_slot)

	var spawn_position: Vector3 = player.get_drop_origin() # Item Drop spawn location
	var direction: Vector3 = player.get_facing_direction() # direction of player facing

	item_drop.position = spawn_position
	item_drop.apply_central_impulse(direction * 2.0)


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
