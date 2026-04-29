extends Control
class_name  DragManager


@export var item_texture: TextureRect
@export var item_quantity_label: Label

@export var slot_data: SlotData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot_data = SlotData.new()

	slot_data.slot_changed.connect(update_dragger)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if item_texture.texture:
		update_position()


func slot_clicked(slot: Slot) -> void:

	# both slot and dragger is empty
	if not (slot.slot_data.item_data or slot_data.item_data): return

	var slot_has_item: bool = slot.slot_data.item_data != null
	var dragger_has_item: bool = slot_data.item_data != null
	var same_item: bool = slot_has_item and dragger_has_item and slot.slot_data.item_data.item_id == slot_data.item_data.item_id


	# slot has item dragger doesnt
	# slot and dragger has different item
	if (slot_has_item and not dragger_has_item) or (slot_has_item and dragger_has_item and not same_item):
		swap_slot_dragger(slot)
	
	# slot is empty but dragger has item
	# slot has same item as dragger
	if (not slot_has_item and dragger_has_item) or same_item:
		add_to_slot(slot)

	update_dragger()
	

func add_to_slot(slot: Slot) -> void:

	slot_data._quantity = slot.add_item(slot_data.item_data, slot_data.quantity)



func swap_slot_dragger(slot: Slot) -> void:
	var temp_slot_data: SlotData = slot.slot_data
	slot.slot_data = slot_data
	slot_data = temp_slot_data

	slot.update_slot()


func update_dragger() -> void:
	print("\n\n UPDATE DRAGGER ")
	print("DRAGGER QUANITYT: " + str(slot_data.quantity))



	if slot_data.quantity <= 0 or not slot_data.item_data:
		print("i been called")
		print("DRAGGER QUANITYT: " + str(slot_data.quantity))
		slot_data._item_data = null
		slot_data._quantity = 0

		item_texture.texture = null
		item_quantity_label.text = ""

		return

	item_texture.texture = slot_data.item_data.texture
	
	item_quantity_label.text = str(slot_data.quantity)
	print("DRAGGER QUANITYT: " + str(slot_data.quantity))
	print("exiting")
	#) -- this prints 10

func update_position() -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()

	item_texture.position.x = mouse_pos.x - (item_texture.size.x / 2)
	item_texture.position.y = mouse_pos.y - (item_texture.size.y / 2)
