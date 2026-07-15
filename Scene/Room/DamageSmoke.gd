extends Area2D

@export var animation_player: AnimationPlayer
@export var timer: Timer
@export var hitbox: Hitbox
@export var damage : float = 1.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var damage_smoke: Area2D

var continuous_targets: Array[Hurtbox] = []
var continuous_timer: Timer
var toggle_timer: Timer

func _ready() -> void:
	animation_player.play("Smoke")
	timer.start(2.0)
	sprite.visible = true
	toggle_timer = Timer.new()
	toggle_timer.wait_time = 3.0
	toggle_timer.one_shot = false
	toggle_timer.autostart = true
	toggle_timer.timeout.connect(_toggle_sprite)
	add_child(toggle_timer)
	if not hitbox.is_continuous:
		hitbox.damage = damage
		hitbox.area_entered.connect(_on_hitbox_area_entered)
		return
	continuous_timer = Timer.new()
	continuous_timer.wait_time = 1.0
	continuous_timer.autostart = true
	continuous_timer.one_shot = false
	add_child(continuous_timer)
	continuous_timer.timeout.connect(_on_continuous_damage)
	hitbox.area_entered.connect(_on_continuous_enter)
	hitbox.area_exited.connect(_on_continuous_exit)

func _toggle_sprite() -> void:
	sprite.visible = not sprite.visible
	if sprite.visible:
		animation_player.play("Smoke")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(damage, Vector2.ZERO)

func _on_continuous_enter(area: Area2D) -> void:
	if area is Hurtbox:
		if not continuous_targets.has(area):
			continuous_targets.append(area)

func _on_continuous_exit(area: Area2D) -> void:
	if area is Hurtbox:
		continuous_targets.erase(area)

func _on_continuous_damage() -> void:
	for target in continuous_targets:
		target.recieved_damage.emit(damage, Vector2.ZERO)
