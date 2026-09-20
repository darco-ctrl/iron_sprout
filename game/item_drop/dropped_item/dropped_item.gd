extends RigidBody3D
class_name  ItemDrop

@export var item_icon: Sprite3D
@export var slot_data: SlotData

@export var pick_wait_timer: Timer

var can_picked_up: bool = false

func _ready() -> void:
	can_picked_up = false

	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true

func update() -> void:
	if slot_data.item_data.item_model:
		var item_model = slot_data.item_data.item_model.instantiate()
		add_child(item_model)

	elif slot_data.item_data.texture:
		item_icon.texture = slot_data.item_data.texture

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !can_picked_up: return

	var player: Player = body as Player

	if player:
		player_pick_up(player)


func player_pick_up(player: Player) -> void:
	var left_over: int = player.player_inventory_manager.add_item(slot_data)

	if left_over <= 0: queue_free()
	else:
		slot_data.quantity = left_over

func _enable_can_picked_up() -> void:
	can_picked_up = true
