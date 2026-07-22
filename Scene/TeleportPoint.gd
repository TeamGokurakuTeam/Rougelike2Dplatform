extends StaticBody2D
class_name TeleportPoint

@export var scene_to_load: PackedScene

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		GameEvents.request_scene_change.emit(scene_to_load)
