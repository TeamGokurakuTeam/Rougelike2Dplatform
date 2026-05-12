extends StaticBody2D
class_name BouncePad

@export var bounce_pwoer : float = 400.0

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_enterd)

func  _on_body_enterd(body : Node) -> void:
	if not body is CharacterBody2D:
		return
	if body.global_position.y < global_position.y:
		var pwoer := bounce_pwoer
		if body.jump_pressed_buffer > 0:
			pwoer += 200
		if body.has_method("external_bounce_jump"):
			body.external_bounce_jump(pwoer)
		else:
			body.velocity.y = -pwoer
