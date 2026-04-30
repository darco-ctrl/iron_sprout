extends Control
class_name  Slot

@export var item_icon: TextureRect
@export var quantity_label: Label
@export var select_indicator: ColorRect

var slot_data: SlotData


func _ready() -> void:
	quantity_label.text = ""

func add_item(new_item_data: ItemData, add_quantity: int) -> int:

	# Wrong item type, skip
	if slot_data.item_data != null and slot_data.item_data.id != new_item_data.id:
		return add_quantity

	# Empty slot
	if slot_data.item_data == null:
		slot_data.item_data = new_item_data

	var space: int = slot_data.item_data.max_quantity - slot_data.quantity
	var added: int = mini(space, add_quantity)

	slot_data.quantity += added
	update_slot()

	return add_quantity - added



func update_label() -> void:
	var temp_str: String = "" 
	
	if slot_data.quantity > 1:
		temp_str = str(slot_data.quantity)
	
	quantity_label.text = temp_str

func update_texture() -> void:
	if slot_data.item_data:
		item_icon.texture = slot_data.item_data.texture
	
	else:
		item_icon.texture = null

func update_slot() -> void:
	if not slot_data.item_data or (slot_data.quantity <= 0):
		slot_data.quantity = 0
		slot_data.item_data = null

		item_icon.texture = null
		quantity_label.text = ""

		

	elif slot_data.quantity > slot_data.item_data.max_quantity:
		var drop_manager: DropManager = GlobalInventoryAccess.drag_manager.drop_manager
		var player_pos = drop_manager.player.position
		
		var sd: SlotData = SlotData.new()

		sd.item_data = slot_data.item_data.duplicate()
		sd.quantity = slot_data.quantity

		drop_manager.drop_item_at_location(sd, player_pos)


	update_label()
	update_texture()
	
func mouse_button_left_clicked() -> void:
	GlobalInventoryAccess.drag_manager.slot_clicked(self)

func _on_gui_input(event: InputEvent) -> void:

	var mouse_event: InputEventMouseButton = event as InputEventMouseButton

	if !mouse_event: return
	if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT and mouse_event.pressed:
		mouse_button_left_clicked()
