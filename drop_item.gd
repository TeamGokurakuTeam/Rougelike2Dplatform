extends Node2D
class_name DropItem

@export var resource : ResourceItem

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	pass
	#sprite_2d.texture = resource.Sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).resource_ids.append(resource.Id)
		queue_free()
