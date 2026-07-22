extends Area2D

@export var damage : float = 10.0

func _ready() -> void:
	connect("body_entered",Callable(self, "_on_body_entered"))

func _on_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
