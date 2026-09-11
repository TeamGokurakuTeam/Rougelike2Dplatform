extends MoveTile
class_name TouchTriggerMoveTile

func _move_progress(delta: float) -> void:
	forward = player_inside
	trail_progress = clamp(trail_progress + delta * move_speed * (1 if forward else -1), 0.0, 1.0)
	current_index = 0
	next_index = 1
