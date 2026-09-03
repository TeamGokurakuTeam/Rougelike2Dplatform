extends State
class_name SkullWolfRage

@export var parent : SkullWolf
@export var animation_player : AnimationPlayer

var tween : Tween
var prev_max_speed : float
var is_cancel : bool = false

func Enter() -> void:
	parent.hitboxes_array[0].damage = 10
	is_cancel = false
	prev_max_speed = parent.max_speed
	animation_player.play("Idle")
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(parent.sprite, "self_modulate", Color("f90000"), 2.0)
	await tween.finished
	if not is_cancel:
		animation_player.play("Attack")
		parent.max_speed = parent.dash_speed
		parent.Dash()
	StateTransitioned.emit(self, "Idle")

func Exit() -> void:
	parent.sprite.self_modulate = Color("ffffff")
	parent.max_speed = prev_max_speed
	parent.prev_state = "Rage"

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	parent.move_and_slide()

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	is_cancel = true
	StateTransitioned.emit(self, "Hurt")

func _on_hp_component_is_dead() -> void:
	is_cancel = true
	StateTransitioned.emit(self, "Dead")
