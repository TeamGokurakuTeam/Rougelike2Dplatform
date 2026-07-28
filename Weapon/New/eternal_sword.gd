extends Weapon
class_name EternalSword

const ETERNAL_SWORD_PROJECTILE = preload("uid://rgc8hhaf3354")

func StrongShot() -> void:
	for i in modifiers_ids.size():
		var projectile : AreaProjectile = ETERNAL_SWORD_PROJECTILE.instantiate()
		get_tree().current_scene.add_child(projectile)
		var pos_y = randf_range(global_position.y - 200, global_position.y - 280)
		var pos_x = randf_range(global_position.x - (15 * i), global_position.x + (15 * i))
		projectile.global_position = Vector2(pos_x, pos_y)
		
