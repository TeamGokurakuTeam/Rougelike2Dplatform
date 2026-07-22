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
		# 1秒ごとにダメージを与えるタイマー
		continuous_timer = Timer.new()
		continuous_timer.wait_time = 1.0
		continuous_timer.autostart = true
		continuous_timer.one_shot = false
		add_child(continuous_timer)
		continuous_timer.timeout.connect(_on_continuous_damage)
		hitbox.area_entered.connect(_on_continuous_enter)
		hitbox.area_exited.connect(_on_continuous_exit)
	else:
		hitbox.damage = damage
		hitbox.area_entered.connect(_on_hitbox_area_entered)

func _on_Timer_timeout() -> void:
	queue_free()

#単発ダメージ
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(hitbox.damage, Vector2.ZERO)

#継続ダメージ
func _on_continuous_enter(area: Area2D) -> void:
	if area is Hurtbox:
		if not continuous_targets.has(area):
			continuous_targets.append(area)

#継続ダメージ終わり
func _on_continuous_exit(area: Area2D) -> void:
	if area is Hurtbox:
		continuous_targets.erase(area)

#1秒ごとに呼ばれる
func _on_continuous_damage() -> void:
	for target in continuous_targets:
		target.recieved_damage.emit(damage, Vector2.ZERO)
