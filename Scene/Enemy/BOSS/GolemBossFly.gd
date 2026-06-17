extends State
class_name GolemBossFly

const ROCK = preload("uid://dqiu3v1k0xk63")

@export var parent : GolemBoss
@export var anim_player : AnimationPlayer
@export var fly_timer : Timer
@export var bullet_shot_timer : Timer
@export var anim_sprite : AnimatedSprite2D

var can_shot_bullet : bool = false
var texture : Texture2D
var bullet_num : int = 6

var min_angle : float = -45
var max_angle : float = 45
var center : Vector2

func _ready() -> void:
	texture = anim_sprite.sprite_frames.get_frame_texture(anim_sprite.animation, anim_sprite.frame)
	center = (texture.get_size()) / 2

func _spawn_bullet(pos : Vector2, angle : float):
	var bullet : CharaProjectile = ROCK.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = pos
	bullet.fire_angle = angle

func Enter() -> void:
	parent.can_move = false
	anim_player.play("FlyStart")
	await anim_player.animation_finished
	fly_timer.start()
	anim_player.play("Flying")
	parent.can_move = true
	can_shot_bullet = true

func Exit() -> void:
	pass

func Update(delta) -> void:
	pass


func Physics_Update(delta) -> void:
	parent.GolemFlyRotate(delta)
	
	
	if can_shot_bullet and bullet_shot_timer.time_left <= 0:
		bullet_shot_timer.start()
	
	#----------------test用----------------#
	if parent.player == null:
		return
	if parent.can_move:
		parent.set_target(parent.player.global_position)
		parent.move_toward_player()
		parent.move_and_slide()
	#--------------------------------------#

#----------------test用----------------#


func _on_fly_timer_timeout() -> void:
	parent.can_move = false
	can_shot_bullet = false
	parent.animation_player.play("FlyEnd")
	await anim_player.animation_finished
	parent.can_move = true
	StateTransitioned.emit(self, "Move")


func _on_bullet_shot_timer_timeout() -> void:
	for i in bullet_num:
		var angle = randf_range(min_angle, max_angle)
		_spawn_bullet(parent.global_position, angle)
