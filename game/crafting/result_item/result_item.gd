extends Control
class_name  ResultItem

@export var item_icon: TextureRect

var recipe_data: RecipeData
var crafting_man: CraftingManager
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_viewport().get_camera_3d().owner as Player
	print(player.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func try_crafting() -> void:
	if not recipe_data: return
	if crafting_man.can_craft(recipe_data):

		var tool_slot: Slot = GlobalInventoryAccess.player_inventory.has_tag(recipe_data.tool_required)
		if not tool_slot: return

		var tool_data: ToolData = tool_slot.slot_data.item_data as ToolData
		if not tool_data: return

		tool_data.durabiltiy -= 1
		tool_slot.update_slot()
		# removes item
		for ingridiant in recipe_data.ingredients:
			GlobalInventoryAccess.player_inventory.remove_item(ingridiant.item, ingridiant.quantity)
		player.player_hunger.add_hunger(-recipe_data.hunger_depletion)

		var slot_data: SlotData = SlotData.new()
		slot_data.item_data = recipe_data.result_item
		slot_data.quantity = recipe_data.result_quantity

		var leflt_over: int = GlobalInventoryAccess.player_inventory.add_item(slot_data)
		if leflt_over <= 0: return

		slot_data = SlotData.new()
		slot_data.item_data = recipe_data.result_item
		slot_data.quantity = leflt_over

		GlobalInventoryAccess.drop_manager.drop_from_player(slot_data)



func _on_gui_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton

	if not mouse_event: return
	if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT and mouse_event.pressed:
		try_crafting()
