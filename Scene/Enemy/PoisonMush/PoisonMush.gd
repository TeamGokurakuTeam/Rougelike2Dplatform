extends Enemy
class_name PoisonMush

const POISON = preload("uid://boyowyd6pk7hb")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func poison_shot() -> void:
	var poison : PoisonProjectile = POISON.instantiate()
	get_tree().current_scene.add_child(poison)
	poison.global_position = Vector2(animated_sprite_2d.global_position.x, animated_sprite_2d.global_position.y - randf_range(-25, 25))
