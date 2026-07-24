extends ComponentHost
class_name RotatingBeam

@export var rotate_speed : float = 40.0

@onready var pivot : Node2D = $Pivot
@onready var beam_area: Hitbox = $Pivot/Hitbox
@onready var trap_component: TrapComponent = $TrapComponent
@onready var center_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var beam_sprite: AnimatedSprite2D = $Pivot/Hitbox/AnimatedSprite2D


func _process(delta: float) -> void:
	if trap_component.is_active:
		pivot.rotation_degrees += rotate_speed * delta

func _on_trap_component_trap_disabled() -> void:
	beam_area.is_active = false
	while beam_sprite.frame != 0 and not trap_component.is_active:
		await get_tree().process_frame

	if not trap_component.is_active:
		beam_sprite.stop()
		beam_sprite.visible = false

	while center_sprite.frame != 0 and not trap_component.is_active:
		await get_tree().process_frame

	if not trap_component.is_active:
		center_sprite.stop()
		center_sprite.visible = false

func _on_trap_component_trap_enabled() -> void:
	beam_area.is_active = true
	beam_sprite.visible = true
	beam_sprite.play()
	center_sprite.visible = true
	center_sprite.play()
