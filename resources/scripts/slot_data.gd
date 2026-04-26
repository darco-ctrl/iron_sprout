extends Resource

class_name SlotData

signal slot_item_changed
signal slot_quantity_changed

var item_data: ItemData:
    set(value):
        item_data = value
        slot_item_changed.emit()

var quantity: int = 0:
    set(value):
        quantity = value
        slot_quantity_changed.emit()

