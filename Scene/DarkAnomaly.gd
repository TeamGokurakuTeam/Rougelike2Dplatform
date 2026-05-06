extends Character
class_name DarkDarkAnomaly

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var state_machine: StateMachine
@export var hp: HPComponent

func _ready() -> void:
	if not hp.is_dead.is_connected(_on_hp_component_is_dead):
		hp.is_dead.connect(_on_hp_component_is_dead)

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	if state_machine.current_state:
		state_machine.current_state.Update(delta)
		state_machine.current_state.Physics_Update(delta)

func _on_hp_component_is_dead() -> void:
	queue_free()
