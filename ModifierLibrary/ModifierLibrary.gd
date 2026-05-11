class_name ModifierLibrary

static func apply_sharp(weapon : Weapon) -> void:
	for hitbox in weapon.hitboxes:
		(hitbox as Hitbox).damage += 5
