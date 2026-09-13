extends Panel
class_name ModifierUIPanel

@onready var texture_rect: TextureRect = $TextureRect
@onready var charge_particle: GPUParticles2D = $ChargeParticle

@export var sparkling : bool = false :
	set(value):
		sparkling = value
		charge_particle.emitting = value

var dissolve_tween : Tween
var is_dissolving : bool = false

func dissolve() -> void:
	if is_dissolving:
		return
	is_dissolving = true
	if dissolve_tween:
		dissolve_tween.kill()
	dissolve_tween = create_tween()
	dissolve_tween.tween_property(texture_rect.material, "shader_parameter/dissolve_value", 0.0, 1.5)
	await dissolve_tween.finished
	is_dissolving = false

func reset_dissolve() -> void:
	is_dissolving = false
	if dissolve_tween:
		dissolve_tween.kill()
	if texture_rect and texture_rect.material:
		texture_rect.material.set_shader_parameter("dissolve_value", 0.7)
