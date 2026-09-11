extends CharacterBody2D
class_name DropModifier

@export var modifier : ModifierResource
@export var is_random : bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var gravity : float = 200

func _ready() -> void:
	if modifier != null:
		sprite.texture = modifier.texture

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
