extends Control
class_name  Slot

@export var item_icon: TextureRect
@export var quantity_label: Label

var slot_data: SlotData

func _ready() -> void:
	quantity_label.text = ""

func add_item(new_item_data: ItemData, add_quantity: int) -> int:


	if slot_data.item_data == null:

		slot_data.item_data = new_item_data
	else:
		return add_quantity

	var space: int = slot_data.item_data.max_quantity - slot_data.quantity
	var added: int = mini(space, add_quantity)
	
	slot_data.quantity += added
	update_slot()

	return add_quantity - added


func update_label() -> void:
	var temp_str: String = "" 
	
	if slot_data.quantity > 0:
		temp_str = str(slot_data.quantity)
	
	quantity_label.text = temp_str

func update_texture() -> void:
	if slot_data.item_data:
		item_icon.texture = slot_data.item_data.texture
	
	else:
		item_icon.texture = null

func update_slot() -> void:
	if slot_data.item_data == null:
		slot_data._quantity = 0

		item_icon.texture = null
		quantity_label.text = ""

	update_label()
	update_texture()
	
func mouse_button_left_clicked() -> void:
	InventoryBuilder.drag_manager.add_item(self)

func _on_gui_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton

	if !mouse_event: return
	if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		mouse_button_left_clicked()
