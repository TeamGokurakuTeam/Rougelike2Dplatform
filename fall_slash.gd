extends Hitbox
class_name PlayerFallProjecttile

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox

#左右判断
var direction := 1

func _ready() -> void:
	if direction == 1:
		animation_player.play("FallSlash")
	else:
		animation_player.play("FallSlashReverse")
	timer.start(1.0)
	self.area_entered.connect(_on_hitbox_area_entered)

func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(self.damage, Vector2.ZERO)
