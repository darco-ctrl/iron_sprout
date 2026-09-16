extends Control
class_name RecipeSlot

@export var indicator: ColorRect
@export var item_icon: TextureRect

var crafting_man: CraftingManager
var recipe_data: RecipeData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

func update() -> void:
	if recipe_data:
		item_icon.texture = recipe_data.result_item.texture

func _on_gui_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton

	if not mouse_event: return
	if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT and mouse_event.pressed:
		crafting_man.select_recipe(recipe_data)

func select() -> void:
	indicator.visible = true

func deselect() -> void:
	indicator.visible = false


