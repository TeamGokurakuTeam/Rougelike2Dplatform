extends Enemy
class_name GoldenPiggy

@onready var player_detector: Area2D = $PlayerDetector

var player: Player
var is_in_hit: bool = false
var timeout : int = 0
var death_timer: Timer

func _ready() -> void:
	super._ready()
	player = get_tree().get_first_node_in_group("Player")
	player_detector.body_entered.connect(_on_player_detector_body_entered)
	death_timer = Timer.new()
	death_timer.wait_time = 5.0
	death_timer.one_shot = true
	death_timer.timeout.connect(_on_death_timeout)
	add_child(death_timer)

func _physics_process(delta: float) -> void:
	super(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	if navigation_agent.is_navigation_finished():
		velocity.x = move_toward(velocity.x, 0, 200.0 * delta)
	else:
		var next := navigation_agent.get_next_path_position()
		var dir := (next - global_position).normalized()
		velocity.x = dir.x * 160.0
	if player != null:
		if player.global_position.x < global_position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	move_and_slide()

func flee_from_player() -> void:
	if player == null:
		return
	var dir := (global_position - player.global_position).normalized()
	var flee_target := global_position + dir * 300.0
	navigation_agent.target_position = flee_target

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		_start_death_timer()
		$StateMachine.current_state.StateTransitioned.emit($StateMachine.current_state, "Discovery")

func _on_death_timeout() -> void:
	$StateMachine.current_state.StateTransitioned.emit($StateMachine.current_state, "Disappear")

func _on_hurtbox_recieved_damage(damage: float, knockback_dir: Vector2) -> void:
	if is_in_hit:
		return
	is_in_hit = true
	_start_death_timer()
	killed_drop_modifier()
	$StateMachine.current_state.StateTransitioned.emit($StateMachine.current_state, "Hit")
func _start_death_timer() -> void:
	if death_timer.is_stopped():
		death_timer.start()
