extends Node3D

@export var item_icon: Sprite3D

@export var slot: SlotData
@export var item_data: ItemData# temporrary
@export var quantity: int # temporrary

func _ready() -> void:
	slot = SlotData.new()

	slot.quantity = 10
	slot.item_data = item_data

	update()

func update() -> void:

	item_icon.texture = slot.item_data.texture

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	var player: Player = body as Player

	if player:
		player_pick_up(player)
		

func player_pick_up(player: Player) -> void:

	var left_over: int = player.inventory.add_item(slot)

	if left_over <= 0: queue_free()
	else:
		slot.quantity = left_over

	