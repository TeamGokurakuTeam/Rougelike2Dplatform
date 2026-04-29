extends Character
class_name Bat

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_hp_component_is_dead() -> void:
	queue_free()
