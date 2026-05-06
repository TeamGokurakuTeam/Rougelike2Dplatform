extends Character
class_name Mage

@export var navigation_agent_2d: NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp = $HPComponent
@export var cool_down: Timer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const HISTORY_LENGTH := 30
var position_history: Array[Vector2] = []
var teleport_prev_data = {}

func _ready() -> void:
	pass

func _on_cool_down_timeout() -> void:
	position_history.append(global_position)
	if position_history.size() > HISTORY_LENGTH:
		position_history.pop_front()

func _on_hp_component_is_dead() -> void:
	queue_free()
