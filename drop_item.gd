extends CharacterBody2D
class_name DropItem

@export var resource : Resource

@onready var sprite_2d: Sprite2D = $Sprite2D

var gravity : float = 500

func _ready() -> void:
	var angle : float = deg_to_rad(randf_range(-60, 60))
	velocity = Vector2.UP.rotated(angle) * 100

	if resource != null:
		if resource is ResourceItem:
			sprite_2d.texture = resource.Sprite
		elif resource is HealItemRes or resource is ModifierResource:
			sprite_2d.texture = resource.texture

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, 500 * delta)

	move_and_slide()
