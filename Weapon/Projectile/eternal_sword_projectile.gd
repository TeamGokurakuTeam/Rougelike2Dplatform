extends AreaProjectile
class_name EternalSwordProjectile

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("init")

func _physics_process(delta: float) -> void:
	position += speed * direction * delta
	if ray_cast_2d.is_colliding():
		if ray_cast_2d.get_collider() is TileMapLayer:
			speed = 0
			animation_player.play("touchdown")
		#var normal : Vector2 = ray_cast_2d.get_collision_normal()
		#if normal.x == 0 and normal.y > 0:
		#	speed = 0
		#	animation_player.play("touchdown")
