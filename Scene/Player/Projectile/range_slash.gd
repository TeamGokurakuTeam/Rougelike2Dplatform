extends Area2D
class_name PlayerRangeProjecttile

@export var timer: Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox
@export var damage : float = 1.0


# 継続ダメージ用
var continuous_targets: Array[Hurtbox] = []
var continuous_timer: Timer

func _ready() -> void:
	if animation_player:
		animation_player.play("RESET")
	timer.start(3.0)
	#継続ダメ
	if hitbox.is_continuous:
		# 0.5秒ごとにダメージを与えるタイマー
		continuous_timer = Timer.new()
		continuous_timer.wait_time = 0.5
		continuous_timer.autostart = true
		continuous_timer.one_shot = false
		add_child(continuous_timer)
	else:
		hitbox.damage = damage

func _on_Timer_timeout() -> void:
	queue_free()
