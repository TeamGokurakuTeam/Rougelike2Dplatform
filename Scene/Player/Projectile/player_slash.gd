extends AreaProjectile
class_name PlayerSlashProjectile

@export var timer : Timer
@export var animation_player : AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	animation_player.play("Destroy")
