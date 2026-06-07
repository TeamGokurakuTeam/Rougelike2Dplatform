extends Node2D
class_name RotatingBeam


@export var rotate_speed : float = 40.0
@onready var pivot : Node2D = $Pivot
@onready var beam_area : Area2D = $Pivot/BeamArea
@onready var anim0 : AnimationPlayer = $AnimationPlayer
@onready var anim1 : AnimationPlayer = $AnimationPlayer2

func _ready() -> void:
	beam_area.connect("body_entered",Callable(self, "_on_beam_hit"))
	anim0.play("Lightning")
	anim1.play("Charge")

func _process(delta: float) -> void:
	pivot.rotation_degrees += rotate_speed * delta

func _on_beam_hit(body : Node) -> void:
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(10)
