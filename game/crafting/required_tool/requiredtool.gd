extends Control
class_name  RequiredTool

@export var tool_required: Label

func update(text: String) -> void:
	tool_required.text = text