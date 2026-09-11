extends State
class_name BatWander

const NEAR_DISTANCE : float = 1.0

@export var min_length : float = 50 ##dir_lengthの最小距離
@export var max_length : float = 150 ##dir_lengthの最大距離
@export var wander_speed : float = 5
@export var accelerator : float = 300

@export var parent : BatMan
@export var anim_player : AnimationPlayer

var random_dir : Vector2
var target_position : Vector2
var start_position : Vector2
var dir_length : float
var wait_timer : float

func Enter() -> void:
	wait_timer = 3
	anim_player.play("BatAnim/IdleWander")
	_set_direction()

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	if parent.hp_component.hp <= 0:
		StateTransitioned.emit(self, "Dead")
	if parent.is_player_entered:
		StateTransitioned.emit(self, "Chase")
	if parent.is_damaged:
		StateTransitioned.emit(self, "hurt")
	wait_timer -= delta
	if parent.get_slide_collision_count() > 0 and wait_timer < 0:
		StateTransitioned.emit(self, "Idle")
	var dir : Vector2 = parent.global_position.direction_to(target_position)
	parent.velocity = parent.velocity.move_toward(dir * wander_speed, delta * accelerator)
	parent.sprite.flip_h = parent.velocity.x < 0
	parent.move_and_slide()
	if parent.global_position.distance_to(target_position) <= NEAR_DISTANCE:
		StateTransitioned.emit(self, "Idle")

func _set_direction() -> void:
	start_position = parent.global_position
	random_dir = Vector2.RIGHT.rotated(randf_range(0, PI * 2))
	#random_dirは方向を0~360度の間に設定する
	dir_length = randf_range(min_length, max_length)
	target_position = start_position + (random_dir * dir_length)

#func _wander(_delta) -> void:
	#velocity = velocity.move_toward(direction * 200, 200 * _delta)
	#sprite.flip_h = velocity.x < 0
	#
	#if global_position.distance_to(Timers.target_position) == WANDER_TARGET_RANGE:
		#Timers.start_wander_timer(randf_range(1,3))
