extends AreaProjectile
class_name EternalSwordProjectile

@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var max_speed : float = 300

var tween : Tween
var can_move : bool = false

func _ready() -> void:
	super()
	await animation_player.animation_finished
	can_move = true
	animation_player.play("init")
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "speed", max_speed , 0.8)

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	position += speed * direction * delta
	if ray_cast_2d.is_colliding():
		if ray_cast_2d.get_collider() is TileMapLayer:
			tween.kill()
			speed = 0
			animation_player.play("touchdown")
			can_move = false
		#var normal : Vector2 = ray_cast_2d.get_collision_normal()
		#if normal.x == 0 and normal.y > 0:
		#	speed = 0
		#	animation_player.play("touchdown")

func _play_spawn_animation() -> void:
	animation_player.play("Spawn")
