extends Panel
class_name ModifierUIPanel

@onready var texture_rect: TextureRect = $TextureRect
@onready var charge_particle: GPUParticles2D = $ChargeParticle

@export var sparkling : bool = false :
	set(value):
		sparkling = value
		charge_particle.emitting = value
