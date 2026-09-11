extends CharaProjectile
class_name FireBall

func _on_timer_timeout() -> void:
	queue_free()
