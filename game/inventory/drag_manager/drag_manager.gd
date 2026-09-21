extends Control
class_name  DragManager

@export var item_texture: TextureRect
@export var item_quantity_label: Label

var slot_data: SlotData

var drop_manager: DropManager
var player: Player

func _ready() -> void:
	slot_data = SlotData.new()

func _process(_delta: float) -> void:
	if item_texture.texture:
		update_position()

	handle_input()

# Called when a slot is clicked
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

# Called when item is to be transfered from Dragger to Slot
func add_to_slot(slot: Slot) -> void:
	slot_data.quantity = slot.add_item(slot_data.item_data, slot_data.quantity)

# Called when item needs to be swaped between dragger and slot
func swap_slot_dragger(slot: Slot) -> void:
	var temp_slot_data: SlotData = slot.slot_data
	slot.slot_data = slot_data
	slot_data = temp_slot_data

	slot.update_slot()

# Updates the dragger
func update_dragger() -> void:
	if slot_data.quantity <= 0 or not slot_data.item_data:
		slot_data.item_data = null
		slot_data.quantity = 0

		item_texture.texture = null
		item_quantity_label.text = ""

		return

	item_texture.texture = slot_data.item_data.icon

	item_quantity_label.text = str(slot_data.quantity)
	#) -- this prints 10

# Updates draggers position
func update_position() -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()

	item_texture.position.x = mouse_pos.x - (item_texture.size.x / 2)
	item_texture.position.y = mouse_pos.y - (item_texture.size.y / 2)


func drop_item() -> void:
	if !slot_data.item_data:
		return

	drop_manager.drop_from_player(slot_data)
	update_dragger()

func handle_input() -> void:
	if Input.is_action_just_pressed("drop_item"):
		drop_item()
