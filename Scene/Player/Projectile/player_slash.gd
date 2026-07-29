extends AreaProjectile
class_name PlayerSlashProjectile

func _on_body_entered(body: Node2D) -> void:
	hit_happened = true
	_resolve_end()
