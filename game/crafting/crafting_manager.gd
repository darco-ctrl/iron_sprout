extends Control
class_name  CraftingManager

@export var recipe_slot_scene: PackedScene

@export var recipe_container: GridContainer
@export var required_tool: RequiredTool
@export var ingridiant_slots: Array[ingredientslot]
@export var result_quantity_label: Label
@export var result_item: ResultItem

@export var recipe_datas: Array[RecipeData]

var is_crafting_menu_open = false
var current_selected_recipe: RecipeData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result_item.crafting_man = self
	visible = is_crafting_menu_open

	create_recipe_slots()

func create_recipe_slots() -> void:
	for recipe_data in recipe_datas:

		var recipe_slot: RecipeSlot = recipe_slot_scene.instantiate()
		recipe_slot.crafting_man = self
		recipe_slot.recipe_data = recipe_data

		recipe_container.add_child(recipe_slot)

func select_recipe(recipe_data: RecipeData) -> void:
	if current_selected_recipe == recipe_data:
		current_selected_recipe = null
		required_tool.tool_required.text = ""

		for i in range(recipe_data.ingredients.size()):
			ingridiant_slots[i].item_icon.texture = null

		result_quantity_label.text = ""
		result_item.item_icon.texture = null
		result_item.recipe_data = null
	else:
		current_selected_recipe = recipe_data
		required_tool.tool_required.text = recipe_data.tool_required

		for i in range(recipe_data.ingredients.size()):
			ingridiant_slots[i].item_icon.texture = recipe_data.ingredients[i].item.icon

		result_quantity_label.text = str(recipe_data.result_quantity)
		result_item.item_icon.texture = recipe_data.result_item.icon
		result_item.recipe_data = recipe_data

func can_craft(recipe_data: RecipeData) -> bool:
	for ingridiant in recipe_data.ingredients:
		var has_item: bool = GlobalInventoryAccess.player_inventory.has_item(ingridiant.item, ingridiant.quantity)

		if not has_item:
			return false

	if not GlobalInventoryAccess.player_inventory.has_tag(recipe_data.tool_required): return false

	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_crafting_menu"):
		is_crafting_menu_open = !is_crafting_menu_open

		visible = is_crafting_menu_open
