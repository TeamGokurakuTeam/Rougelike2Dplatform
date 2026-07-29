extends Area2D
class_name AreaProjectile

@export_category("発射物のエフェクトシーン")
@export var impact_effect_scene : PackedScene

@export_category("ステータス")
@export var speed : float = 200
@export var direction : Vector2 = Vector2.RIGHT
@export var spawn_grace_period: float = 0.01 #発射されてから当たり判定が有効になるまでの秒数
@export var animation_player: AnimationPlayer
@export var timer: Timer

@onready var animated_sprite_2d: AnimatedSprite2D = $VisualRoot/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox

var hit_position : Vector2 = Vector2.ZERO
var hit_happened : bool = false

var _can_spawn_impact_effect : bool = false

func _ready() -> void:
	_play_spawn_animation()
 
	if timer:
		timer.start()

func _process(_delta: float) -> void:
	if not hit_happened:
		hit_position = global_position

func _physics_process(delta: float) -> void:
	position += speed * direction * delta
	animated_sprite_2d.rotation = direction.angle()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func destory() -> void:
	speed = 0
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		hit_happened = true
		_resolve_end()

func _resolve_end() -> void:
	if _can_spawn_impact_effect:
		_spawn_impact_effect()
	destory()

func _spawn_impact_effect() -> void:
	if impact_effect_scene == null:
		return
	var effect := impact_effect_scene.instantiate()
	effect.global_position = hit_position
	get_tree().current_scene.add_child(effect)

#region スポーン時当たり判定を一瞬無効にする
func _start_grace_period() -> void:
	hitbox.monitoring = false
	hitbox.monitorable = false
	var grace_timer := Timer.new()
	grace_timer.wait_time = spawn_grace_period
	grace_timer.one_shot = true
	grace_timer.timeout.connect(_on_enable_collision)
	add_child(grace_timer)
	grace_timer.start()

func _on_enable_collision() -> void:
	_can_spawn_impact_effect = true
	hitbox.monitoring = true
	hitbox.monitorable = true
#endregion

#region override_function
func _play_spawn_animation() -> void:
	pass
#endregion
