extends StaticBody2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Idle")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_player.play("Close")

func open() -> void:
	animation_player.play("Open")
