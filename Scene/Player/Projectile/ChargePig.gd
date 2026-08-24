extends Area2D
class_name ChargePig

@export var damage: float = 3.0
@export var velocity: Vector2 = Vector2.ZERO

@onready var hitbox: Hitbox = $Hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	if animation_player:
		animation_player.play("Pig")
	hitbox.damage = damage
	hitbox.area_entered.connect(_on_hitbox_entered)
	monitoring = false
	monitorable = false
	var delay := Timer.new()
	delay.wait_time = 0.01
	delay.one_shot = true
	delay.timeout.connect(func():
		monitoring = true
		monitorable = true
	)
	add_child(delay)
	delay.start()
	timer.wait_time = 1
	timer.start()

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func _on_hitbox_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(damage, Vector2.ZERO)
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
