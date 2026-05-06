extends Character
class_name Knight

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp = $HPComponent

const SPEED = 300.0
var is_shielding: bool = false

func _ready() -> void:
	hp.damaged.connect(_on_hp_damaged)

func _on_hp_damaged(amount: int) -> void:
	$StateMachine.current_state.StateTransitioned.emit($StateMachine.current_state, "Hit")

func _on_hp_component_is_dead() -> void:
	queue_free()
