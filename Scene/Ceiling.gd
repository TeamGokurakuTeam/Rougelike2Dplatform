extends Node2D
class_name Ceiling

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sensor: Area2D = $Area2D

func _ready() -> void:
	sensor.body_entered.connect(_on_area_2d_body_entered)
	animation_player.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	animation_player.play("Ceiling")
