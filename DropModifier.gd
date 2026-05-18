extends CharacterBody2D
class_name DropModifier

@export var modifier : Array[ResourceItem]

@onready var sprite_2d: Sprite2D = $Sprite2D

var gravity : float = 200

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
