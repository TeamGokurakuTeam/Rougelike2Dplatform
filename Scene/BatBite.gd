extends State
class_name BatBite

@export var animation_player: AnimationPlayer
@export var parent : Bat

var player : Player
var dash_direction : Vector2 = Vector2.ZERO
const DASH_SPEED := 1200.0
const X_BOOST := 1.3  

func Enter() -> void:
	animation_player.play("Bite")
	animation_player.animation_finished.connect(_on_bite_finished, CONNECT_ONE_SHOT)

	if get_tree().get_node_count_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]

	if player:
		dash_direction = (player.global_position - parent.global_position).normalized()
	else:
		dash_direction = Vector2.ZERO

	dash_direction.x *= X_BOOST
	dash_direction = dash_direction.normalized()

func Exit() -> void:
	parent.velocity = Vector2.ZERO

func Physics_Update(delta: float) -> void:
	parent.velocity = dash_direction * DASH_SPEED
	parent.move_and_slide()

func _on_bite_finished(anim_name: String) -> void:
	if anim_name == "Bite":
		StateTransitioned.emit(self, "Idle")
