extends StaticBody2D
class_name BouncePad

@export var bounce_power : float = 400.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	if body.global_position.y < global_position.y:
		var power := bounce_power
		if body.jump_pressed_frame > 0:
			power += 200
		if body.has_method("external_bounce_jump"):
			body.external_bounce_jump(power)
		else:
			body.velocity.y = -power
