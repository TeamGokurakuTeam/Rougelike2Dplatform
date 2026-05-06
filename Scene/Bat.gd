extends Character
class_name Bat

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var cool_down: Timer
@export var bite_timer: Timer

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	move_and_slide()

func distance_to_player() -> float:
	if get_tree().get_node_count_in_group("Player") == 0:
		return INF
	var player = get_tree().get_nodes_in_group("Player")[0]
	return global_position.distance_to(player.global_position)

func _on_hp_component_is_dead() -> void:
	queue_free()
