
@tool
extends Sprite2D
class_name WaterfallEffect

func _process(delta) -> void:
	var shader_material : ShaderMaterial = material
	shader_material.set_shader_parameter("zoom", get_viewport_transform().y.y)
	shader_material.set_shader_parameter("scale", scale)
