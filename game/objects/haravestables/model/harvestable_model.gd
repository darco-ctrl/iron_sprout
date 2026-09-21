extends Node3D
class_name  HarvestableModel

@export var mesh_instance: MeshInstance3D
@export var material_overlay: ShaderMaterial

var is_focused: bool = false

func _ready() -> void:
	on_hover_exit()

func set_mesh(mesh: Mesh):
	mesh_instance.mesh = mesh

func on_hover_enter():
	print("hover")
	if is_focused: return

	is_focused = true
	material_overlay.set_shader_parameter("outline_color", Color.WHITE)

func on_hover_exit():
	if !is_focused: return

	is_focused = false
	material_overlay.set_shader_parameter("outline_color", Color.BLACK)
