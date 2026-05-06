extends State
class_name BatBite

@export var animation_player: AnimationPlayer
@export var parent: Bat

const DASH_SPEED := 150.0
var player: Player
var dash_direction: Vector2 = Vector2.ZERO
var transitioned := false

func Enter() -> void:
	animation_player.play("Bite")
	transitioned = false
	parent.velocity = Vector2.ZERO
	if get_tree().get_node_count_in_group("Player") > 0:
		player = get_tree().get_nodes_in_group("Player")[0]
	if player:
		dash_direction = (player.global_position - parent.global_position).normalized()
	else:
		dash_direction = Vector2.ZERO

func Exit() -> void:
	parent.velocity = Vector2.ZERO

func Update(delta: float) -> void:
	if not transitioned and not animation_player.is_playing():
		transitioned = true
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta: float) -> void:
	parent.velocity = dash_direction * DASH_SPEED
	parent.move_and_slide()
