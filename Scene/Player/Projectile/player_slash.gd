extends AreaProjectile
class_name PlayerSlashProjectile

@export var timer : Timer
@export var animation_player : AnimationPlayer

#位置の保存
var range_slash_scene: PackedScene
var spawn_position: Vector2 = Vector2.ZERO
var hit_position: Vector2 = Vector2.ZERO
var can_spawn_range_slash := false
var hit_happened := false

func _ready() -> void:
	#位置の取得
	timer.start(3.0)
	monitoring = false
	monitorable = false
	var delay := Timer.new()
	delay.wait_time = 0.01
	delay.one_shot = true
	delay.timeout.connect(_enable_spawn)
	add_child(delay)
	delay.start()

func _enable_spawn() -> void:
	can_spawn_range_slash = true
	monitorable = true
	monitoring = true

func _process(delta: float) -> void:
	if not hit_happened:
		hit_position = global_position

func _on_timer_timeout() -> void:
	if can_spawn_range_slash:
		_spawn_range_slash()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	hit_position = global_position
	hit_happened = true
	if body.is_in_group("Enemy"):
		if can_spawn_range_slash:
			_spawn_range_slash()
		queue_free()
		return
	if not can_spawn_range_slash:
		queue_free()
		return
	_spawn_range_slash()
	queue_free()

func _spawn_range_slash() -> void:
	if range_slash_scene != null:
		var slash := range_slash_scene.instantiate()
		slash.global_position = hit_position
		get_tree().current_scene.add_child(slash)
