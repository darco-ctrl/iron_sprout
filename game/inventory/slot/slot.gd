extends Control
class_name  Slot

@export var item_icon: TextureRect
@export var quantity_label: Label

var slot_data: SlotData

func _ready() -> void:
	slot_data = SlotData.new()

	quantity_label.text = ""

func add_item(new_item_data: ItemData, add_quantity: int) -> int:

	var update_texture: bool = false

	if slot_data.item_data == null:

		slot_data.item_data = new_item_data

		update_texture = true
	else:
		return add_quantity

	var space: int = slot_data.item_data.max_quantity - slot_data.quantity
	var added: int = mini(space, add_quantity)
	
	slot_data.quantity += added
	update_slot(update_texture)

	return add_quantity - added


func update_slot(update_texture: bool = false) -> void:
	
	if update_texture:
		item_icon.texture = slot_data.item_data.texture
	
	var quantity_string: String = ""

	if slot_data.quantity > 0:
		quantity_string = str(slot_data.quantity)

	quantity_label.text = quantity_string