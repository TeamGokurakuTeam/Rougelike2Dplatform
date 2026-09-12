extends Node2D
class_name Radiation

const FIXED_TIME := 3.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	animation_player.play("Radiation")
	timer.wait_time = FIXED_TIME
	timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Radiation":
			timer.wait_time = FIXED_TIME
			timer.start()
		"RadiationCountdown":
			animation_player.play("Meltdown")
		"Meltdown":
			timer.stop()
			timer.wait_time = FIXED_TIME
			timer.start()
			animation_player.play("Radiation")

func _on_timer_timeout() -> void:
	match animation_player.current_animation:
		"Radiation":
			animation_player.play("RadiationCountdown")
		"RadiationCountdown":
			animation_player.play("Meltdown")
		"Meltdown":
			animation_player.play("Radiation")
