extends CharaProjectile
class_name PoisonProjectile

@onready var life_timer: Timer = $LifeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $VisualRoot/AnimatedSprite2D

var rotation_tween : Tween

func _ready() -> void:
	animation_player.play("Start")
	life_timer.start()
	rotation_tween = create_tween()
	
	rotation_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
	if randi_range(1, 50) <= 25:
		rotation_tween.tween_property(animated_sprite_2d, "rotation_degrees", 360, 5.0)
	else:
		rotation_tween.tween_property(animated_sprite_2d, "rotation_degrees", -360, 5.0)
	
	await animation_player.animation_finished
	animation_player.play("Normal")

func _on_life_timer_timeout() -> void:
	animation_player.play("End")
