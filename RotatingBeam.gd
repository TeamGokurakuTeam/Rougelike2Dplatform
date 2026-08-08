extends Node2D
class_name RotatingBeam

@export var rotate_speed : float = 40.0
@export var continuous_damage : float = 5.0
@export var first_hit_damage : float = 5.0

@onready var pivot : Node2D = $Pivot
@onready var beam_area: Hitbox = $Pivot/Hitbox
@onready var anim0 : AnimationPlayer = $AnimationPlayer

var is_player_inside := false
var player_ref : Node = null
var continuous_timer := 0.0
func _ready() -> void:
	anim0.play("Lightning")
	beam_area.connect("body_entered", Callable(self, "_on_hitbox_body_entered"))
	beam_area.connect("body_exited", Callable(self, "_on_hitbox_body_exited"))

func _process(delta: float) -> void:
	pivot.rotation_degrees += rotate_speed * delta

	if is_player_inside and player_ref != null:
		# ★ 1秒以内なら継続ダメージ
		if continuous_timer < 1.0:
			continuous_timer += delta
			if player_ref.has_method("take_damage"):
				player_ref.take_damage(continuous_damage * delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = true
		player_ref = body
		if body.has_method("take_damage"):
			body.take_damage(first_hit_damage)
		continuous_timer = 0.0

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = false
		player_ref = null
		continuous_timer = 0.0
