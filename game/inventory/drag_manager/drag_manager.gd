extends Control
class_name  DragManager

@export var item_texture: TextureRect
@export var item_quantity_label: Label

var slot_data: SlotData

var drop_manager: DropManager
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot_data = SlotData.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if item_texture.texture:
		update_position()


func slot_clicked(slot: Slot) -> void:

	# both slot and dragger is empty
	if not (slot.slot_data.item_data or slot_data.item_data): return

	var slot_has_item: bool = slot.slot_data.item_data != null
	var dragger_has_item: bool = slot_data.item_data != null
	var same_item: bool = slot_has_item and dragger_has_item and slot.slot_data.item_data.id == slot_data.item_data.id


	# slot has item dragger doesnt
	# slot and dragger has different item
	if (slot_has_item and not dragger_has_item) or (slot_has_item and dragger_has_item and not same_item):
		swap_slot_dragger(slot)
	
	# slot is empty but dragger has item
	# slot has same item as dragger
	elif (not slot_has_item and dragger_has_item) or same_item:
		add_to_slot(slot)

	update_dragger()
	

func add_to_slot(slot: Slot) -> void:

	slot_data.quantity = slot.add_item(slot_data.item_data, slot_data.quantity)
	



func swap_slot_dragger(slot: Slot) -> void:
	var temp_slot_data: SlotData = slot.slot_data
	slot.slot_data = slot_data
	slot_data = temp_slot_data

	slot.update_slot()


func update_dragger() -> void:

	if slot_data.quantity <= 0 or not slot_data.item_data:
		slot_data.item_data = null
		slot_data.quantity = 0

		item_texture.texture = null
		item_quantity_label.text = ""

		return

	item_texture.texture = slot_data.item_data.texture
	
	item_quantity_label.text = str(slot_data.quantity)
	#) -- this prints 10

func update_position() -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()

	item_texture.position.x = mouse_pos.x - (item_texture.size.x / 2)
	item_texture.position.y = mouse_pos.y - (item_texture.size.y / 2)


func drop_item() -> void:
	if slot_data.item_data:
		drop_manager.drop_item(slot_data)
		update_dragger()

func _on_gui_input(event: InputEvent) -> void:

	var mouse_event = event as InputEventMouseButton

	if !mouse_event: return
	if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT and mouse_event.pressed:
		drop_item()
