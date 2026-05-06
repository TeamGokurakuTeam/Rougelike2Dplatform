extends CharacterBody2D
class_name DropItem

@export var resource : ResourceItem

@onready var sprite_2d: Sprite2D = $Sprite2D

var gravity : float = 500

func _ready() -> void:
	if resource != null:
		sprite_2d.texture = resource.Sprite

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

func _on_drop_item_area_area_entered(area: Area2D) -> void:
	if area is PickupComponent:
		queue_free()
