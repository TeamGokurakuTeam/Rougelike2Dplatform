extends Character
class_name Knight

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp = $HPComponent
var is_shielding: bool = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
func _ready() -> void:
	hp.damaged.connect(_on_hp_damaged)





func _physics_process(delta: float) -> void:
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
	face_move_direction()


func face_move_direction() -> void:
	var dir = navigation_agent.velocity.x

	if dir == 0:
		return

	if dir > 0:
		animation_player.get_parent().flip_h = false
	else:
		animation_player.get_parent().flip_h = true

func _on_hp_damaged(amount: int) -> void:
	var state = $StateMachine.current_state

	if state.name == "Move" or state.name == "Idle":
		state.StateTransitioned.emit(state, "Hit")


func _on_hit_finished(anim_name: String) -> void:
	if anim_name == "Hit":
		animation_player.play("Move")


func _on_hp_component_is_dead() -> void:
	queue_free()
