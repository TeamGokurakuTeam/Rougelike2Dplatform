extends Area2D
class_name Hurtbox

@export var character : Character

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var cool_down: Timer = $CoolDown

var current_area : Area2D
var is_stop_timer : bool = false

signal recieved_damage(damage : float, knockback_dir : Vector2)

func _on_area_entered(area: Area2D) -> void:
	if area != null and area is Hitbox:
		cool_down.start()
		current_area = area
		recieved_damage.emit(area.damage * area.damage_multiplier, area.knockback_force * area.knockback_direction)

func _on_cool_down_timeout() -> void:
	if not is_stop_timer and current_area != null:
		current_area = null
	is_stop_timer = false
