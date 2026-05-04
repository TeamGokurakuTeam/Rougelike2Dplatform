extends State
class_name BatIdle

@export var animation_player: AnimationPlayer
@export var parent: Bat

var idle_timer := 0.2 

func Enter() -> void:
	animation_player.play("Idle")
	idle_timer = 0.2

func Update(delta: float) -> void:
	idle_timer -= delta

	# ★ 硬直が終わったら Move に戻る
	if idle_timer <= 0:
		StateTransitioned.emit(self, "Move")
