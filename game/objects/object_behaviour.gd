extends Node3D
class_name ObjectBehavior

@export var object_data: ObjectData

func on_hover_enter() -> void: pass
func on_hover_exit() -> void: pass
func on_hit(_tool_data: ToolData) -> void: pass
func on_interact(_tool_data: ToolData) -> void: pass
func on_break_get_item() -> Array[SlotData]: return[]
