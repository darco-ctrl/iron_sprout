extends Control
class_name  DragManager


@export var item_texture: TextureRect
@export var item_quantity_label: Label

var slot_data: SlotData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slot_data = SlotData.new()

	slot_data.slot_changed.connect(update_dragger)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if item_texture.texture:
		update_position()


func add_item(clicked_slot: Slot) -> void:
	if not clicked_slot.slot_data.item_data: return

	var temp_slot_data: SlotData = clicked_slot.slot_data
	clicked_slot.slot_data = slot_data
	slot_data = temp_slot_data

	update_dragger()

func update_dragger() -> void:
	if not slot_data.item_data:
		item_texture.texture = null
		item_quantity_label.text = ""
		slot_data.quantity = 0

		return

	item_texture.texture = slot_data.item_data.texture

	var quantity_string: String = ""
	if slot_data.quantity > 0:
		quantity_string = str(slot_data.quantity)
	
	item_quantity_label.text = quantity_string

func update_position() -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()

	item_texture.position.x = mouse_pos.x - (item_texture.size.x / 2)
	item_texture.position.y = mouse_pos.y + (item_texture.size.y / 2)
