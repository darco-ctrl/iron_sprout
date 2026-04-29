extends Resource

class_name SlotData

signal slot_changed

var _item_data: ItemData
var item_data: ItemData:
    set(value):
        _item_data = value
        slot_changed.emit()
    get:
        return _item_data

var _quantity: int = 0
var quantity: int:
    set(value):
        _quantity = value
        slot_changed.emit()
    get:
        return _quantity



