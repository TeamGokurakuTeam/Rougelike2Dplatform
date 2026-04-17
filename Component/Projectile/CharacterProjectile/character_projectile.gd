extends CharacterBody2D
class_name CharaProjectile

@export var speed : float = 200
@export var direction : Vector2 = Vector2.LEFT

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox

func _physics_process(delta: float) -> void:
	#position += speed * direction * delta
	velocity = speed * direction
	velocity = velocity.limit_length(speed)
	sprite.rotation = direction.angle()
	
	var collided : KinematicCollision2D = move_and_collide(velocity)
	if collided:
		var normal : Vector2 = collided.get_normal()
		direction = velocity.bounce(normal).normalized()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

#func parry_reflect(weapon : Weapon) -> void:
	#hitbox.set_collision_layer_value(3, false) #layer Enemy off
	#hitbox.set_collision_layer_value(2, true) #layer Player on
	#hitbox.set_collision_layer_value(5, true) #layer Reflect on
	#hitbox.set_collision_mask_value(2, false)
	#hitbox.set_collision_mask_value(3, true)
	#direction = Vector2( -direction.x, -direction.y )
	###direction = direction * weapon.angle * 1.2
	#if weapon.angle > 0.5:
		#direction = direction * weapon.angle
	#else:
		#direction = direction 

func destory() -> void:
	speed = 0
	animation_player.play(&"destroy")
