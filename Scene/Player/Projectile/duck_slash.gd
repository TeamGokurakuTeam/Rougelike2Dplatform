extends Area2D
class_name DuckProjectile

@export var timer: Timer
@export var animation_player: AnimationPlayer
@export var range_slash_scene: PackedScene
@export var damage: float = 3.0
@onready var hitbox: Hitbox = $Hitbox

var velocity: Vector2 = Vector2.ZERO
var duck_gravity: float = 900.0
var can_spawn_range_slash: bool = false
var hit_position: Vector2 = Vector2.ZERO
var hit_happened: bool = false

# バウンド設定
var bounce_speed_multiplier := 1.1
var max_speed := 800

func _ready() -> void:
	if animation_player:
		animation_player.play("RollDuck")
	timer.start(1.0)
	hitbox.damage = damage
	hitbox.area_entered.connect(_on_hitbox_entered)
	var delay := Timer.new()
	delay.wait_time = 0.01
	delay.one_shot = true
	delay.timeout.connect(_enable_spawn)
	add_child(delay)
	delay.start()
	monitoring = false
	monitorable = false

func _enable_spawn() -> void:
	can_spawn_range_slash = true
	monitoring = true
	monitorable = true


func _physics_process(delta: float) -> void:
	velocity.y += duck_gravity * delta
	global_position += velocity * delta
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + velocity.normalized() * 10
	)
	var result := space_state.intersect_ray(params)
	if result.size() > 0:
		_bounce(result.normal)

func _process(delta: float) -> void:
	if not hit_happened:
		hit_position = global_position

func _bounce(normal: Vector2) -> void:
	velocity = velocity.bounce(normal)
	velocity *= bounce_speed_multiplier
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

func _on_hitbox_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(damage, Vector2.ZERO)
		hit_happened = true
		if can_spawn_range_slash:
			_spawn_range_slash()
		queue_free()

func _on_timer_timeout() -> void:
	if can_spawn_range_slash:
		_spawn_range_slash()
	queue_free()

func _spawn_range_slash() -> void:
	if range_slash_scene != null:
		var slash := range_slash_scene.instantiate()
		slash.global_position = hit_position
		get_tree().current_scene.add_child(slash)
