extends AreaProjectile
class_name EternalSwordProjectile

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_speed : float = 300

var tween : Tween = create_tween()

func _ready() -> void:
	animation_player.play("init")
	tween.tween_property(self, "speed", max_speed , 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)

func _physics_process(delta: float) -> void:
	position += speed * direction * delta
	if ray_cast_2d.is_colliding():
		if ray_cast_2d.get_collider() is TileMapLayer:
			tween.kill()
			speed = 0
			animation_player.play("touchdown")
		#var normal : Vector2 = ray_cast_2d.get_collision_normal()
		#if normal.x == 0 and normal.y > 0:
		#	speed = 0
		#	animation_player.play("touchdown")
