extends Area2D
class_name DropItem

@export var resource : ResourceItem

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if resource != null:
		sprite_2d.texture = resource.Sprite

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		queue_free()
