extends Character
class_name Enemy

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	super(delta)
	if velocity.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif velocity.x <= 0 and not sprite.flip_h:
		sprite.flip_h = true

func _on_hp_component_is_dead() -> void:
	queue_free()
