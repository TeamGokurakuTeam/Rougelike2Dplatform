extends Hitbox
class_name PlayerFallProjecttile

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Hitbox = $Hitbox

@onready var root: Node2D = $Root
@onready var ghost_timer: Timer = $GhostTimer
@onready var ghost_original: Sprite2D = $Ghost

var h_frames : bool = false
var direction := 1   # 左右判断

func _ready() -> void:
	if direction == 1:
		animation_player.play("FallSlash")
	else:
		animation_player.play("FallSlashReverse")

	timer.start(1.0)
	ghost_timer.start()

	self.area_entered.connect(_on_hitbox_area_entered)

func _on_GhostTimer_timeout() -> void:
	var ghost := ghost_original.duplicate()
	ghost.set_property(
		root.global_position,
		root.scale
	)
	get_tree().current_scene.add_child(ghost)

func _on_timer_timeout() -> void:
	ghost_timer.stop()
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.recieved_damage.emit(self.damage, Vector2.ZERO)
