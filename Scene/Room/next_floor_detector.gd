extends Area2D
class_name NextFloorDetector

var _is_triggered : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node) -> void:
	if body is Player and not _is_triggered:
		_is_triggered = true
		GameEvents.next_floor_entered.emit()
