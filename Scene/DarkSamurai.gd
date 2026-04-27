extends Character
class_name DarkSamurai

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	super(delta)
	if velocity.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif velocity.x <= 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
