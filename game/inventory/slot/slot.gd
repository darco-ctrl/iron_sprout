extends Control
class_name  Slot

@export var item_icon: TextureRect
@export var quantity_label: Label
@export var tool_durabilty: ProgressBar

var selectable: bool = false
var selected: bool = false
var selection_indiecator: ColorRect

var slot_data: SlotData

func _ready() -> void:
	quantity_label.text = ""

func create_slot_data() -> void:
	slot_data = SlotData.new()

	slot_data.slot = self

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
	var is_slot_empty = not slot_data.item_data or (slot_data.quantity <= 0)
	if is_slot_empty:
		free_slot()

	else:
		var tool_data: ToolData = slot_data.item_data as ToolData
		if tool_data: 
			tool_durabilty.visible = true

			if tool_data.durabiltiy <= 0:
				free_slot()

			else:
				tool_durabilty.max_value = tool_data.max_durability
				tool_durabilty.value = tool_data.durabiltiy

	if not is_slot_empty and slot_data.quantity > slot_data.item_data.max_quantity:
		var drop_manager: DropManager = GlobalInventoryAccess.drag_manager.drop_manager
		var player_pos = drop_manager.player.position
		
		var sd: SlotData = SlotData.new()

		sd.item_data = slot_data.item_data.duplicate()
		sd.quantity = slot_data.quantity

		drop_manager.drop_item_at_location(sd, player_pos)

	update_label()
	update_texture()

func free_slot() -> void:
	slot_data.quantity = 0
	slot_data.item_data = null

	item_icon.texture = null
	quantity_label.text = ""
	tool_durabilty.visible = false

func mouse_button_left_clicked() -> void:
	GlobalInventoryAccess.drag_manager.slot_clicked(self)

func _on_gui_input(event: InputEvent) -> void:

	var mouse_event: InputEventMouseButton = event as InputEventMouseButton

	if !mouse_event: return
	if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT and mouse_event.pressed:
		mouse_button_left_clicked()

func set_selected(state: bool) -> void:
	if not selectable: return

	selection_indiecator.visible = state

func set_selectable(state: bool) -> void:
	selectable = state
	if selectable:
		selection_indiecator = ColorRect.new()
		selection_indiecator.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		selection_indiecator.visible = selected
		add_child(selection_indiecator)
		move_child(selection_indiecator, 0)
	
