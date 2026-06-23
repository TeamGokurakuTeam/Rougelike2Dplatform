extends Area2D
class_name PlayerRangeProjecttile

@export var timer: Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox
@export var damage : float = 1.0

func _ready() -> void:
	if animation_player:
		animation_player.play("RESET")
	timer.start(3.0)
	hitbox.damage = damage
	hitbox.area_entered.connect(_on_hitbox_area_entered)

func _process(delta: float) -> void:
	pass

func _on_Timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(hitbox.damage, Vector2.ZERO)
