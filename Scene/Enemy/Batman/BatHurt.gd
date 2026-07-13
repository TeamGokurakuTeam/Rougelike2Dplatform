extends State
class_name BatHurt

@export var parent : Bat
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("BatAnim/hurt")

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass

func Physics_Update(delta) -> void:
	var dir = parent.velocity.normalized() #現在の方向を取得
	var spd = parent.velocity.length() #普通にスピード
	spd = max(spd - parent.max_speed, 0) #実質limit_lengthみたいな感じ
	parent.velocity = dir * spd
	var collided : KinematicCollision2D = parent.move_and_collide(parent.velocity * delta)
	if collided:
		var normal : Vector2 = collided.get_normal() ##ぶつかったボディを90度のベクトル(normal)で返す
		parent.velocity = parent.velocity.bounce(normal)
		if collided.get_collider() is TileMapLayer:
			if parent.hp_component.hp <= 0:
				StateTransitioned.emit(self, "Dead")
				return
		parent.knockback_dir = parent.velocity.normalized()
		parent.hitbox.knockback_direction = parent.knockback_dir
	if parent.velocity.is_zero_approx():
		parent.is_damaged = false
		StateTransitioned.emit(self, "Attack")
