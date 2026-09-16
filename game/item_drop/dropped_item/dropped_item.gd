extends Node3D
class_name  ItemDrop

@export var item_icon: Sprite3D

@export var slot_data: SlotData

func update() -> void:
	if slot_data.item_data:
		item_icon.texture = slot_data.item_data.texture

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	var player: Player = body as Player

	if player:
		player_pick_up(player)
		

func player_pick_up(player: Player) -> void:


	var left_over: int = player.player_inventory_man.add_item(slot_data)

	if left_over <= 0: queue_free()
	else:
		slot_data.quantity = left_over
		

	
