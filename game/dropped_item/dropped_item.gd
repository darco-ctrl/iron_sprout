extends Node3D

@export var item_icon: Sprite2D

@export var item_data: ItemData

func _ready() -> void:
	update()

func update() -> void:
	item_icon.texture = item_data.texture

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	var player: Player = body as Player

	if player:
		pass