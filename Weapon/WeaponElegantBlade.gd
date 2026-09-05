extends Weapon
class_name ElegantBlade

@export var max_charge_scale := 1.5
@export var charge_speed := 0.5
@export var charge_delay := 0.15
@export var charge_particle_2: GPUParticles2D

var charge_time := 0.0
var original_scale := Vector2.ONE
var charge_scale := Vector2.ONE

func _ready() -> void:
	super._ready()
	original_scale = root.scale
	charge_scale = original_scale
	animation_player.animation_started.connect(_on_animation_started)
	animation_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	super._process(delta)
	var anim := animation_player.current_animation
	if anim == "StrongAttack":
		return
	if anim == "Charge":
		charge_time += delta
		if charge_time >= charge_delay:
			charge_scale.x = min(charge_scale.x + charge_speed * delta, max_charge_scale)
			charge_scale.y = min(charge_scale.y + charge_speed * delta, max_charge_scale)
			root.scale = charge_scale
		else:
			root.scale = original_scale
	else:
		if charge_particle_2.emitting:
			root.scale = charge_scale
		else:
			root.scale = original_scale
			charge_scale = original_scale
		charge_time = 0.0

func _on_animation_started(anim_name: StringName) -> void:
	if anim_name == "Attack":
		attack_trigger_modifier()

	if anim_name == "StrongAttack":
		attack_trigger_modifier()
		root.scale = charge_scale

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Charge":
		charge_particle_2.emitting = true

	if anim_name == "StrongAttack":
		root.scale = original_scale
		charge_scale = original_scale
		charge_time = 0.0
		charge_particle_2.emitting = false
