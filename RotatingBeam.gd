extends Node2D
class_name RotatingBeam

@export var rotate_speed : float = 40.0

@onready var pivot : Node2D = $Pivot
@onready var beam_area: Hitbox = $Pivot/Hitbox
@onready var anim : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("Lightning")

func _process(delta: float) -> void:
	pivot.rotation_degrees += rotate_speed * delta
