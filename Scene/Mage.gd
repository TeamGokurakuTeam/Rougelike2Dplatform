extends Character
class_name Mage

@export var navigation_agent_2d: NavigationAgent2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp = $HPComponent

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var position_history: Array[Vector2] = []
var history_timer := 0.0
const HISTORY_INTERVAL := 0.1  
const HISTORY_LENGTH := 80    

func _physics_process(delta: float) -> void:
	history_timer += delta
	if history_timer >= HISTORY_INTERVAL:
		history_timer = 0.0
		position_history.append(global_position)
		if position_history.size() > HISTORY_LENGTH:
			position_history.pop_front()

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_hp_component_is_dead() -> void:
	queue_free()
