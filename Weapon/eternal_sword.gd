extends Weapon
class_name EternalSword

const ETERNAL_SWORD_PROJECTILE = preload("uid://rgc8hhaf3354")

func StrongShot() -> void:
	var projectile : AreaProjectile = ETERNAL_SWORD_PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = Vector2(global_position.x, global_position.y - 150)
	
