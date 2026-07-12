extends Enemy
class_name Bat

const GHOST_EFFECT = preload("uid://b3d4vmf5tf2os")

@onready var ghost_timer: Timer = $GhostTimer

var is_player_entered : bool = false
var target : Player

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func get_path_to_player_point(navigation_agent : NavigationAgent2D) -> void:
	if target == null:
		set_target()
	else:
		navigation_agent.target_position = target.global_position

func set_target() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	if player.size() != 0:
		target = player.pick_random()
	else:
		target = null

func _on_path_timer_timeout() -> void:
	get_path_to_player_point(navigation_agent)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_entered = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_entered = false

func add_ghost_effect() -> void:
	var ghost = GHOST_EFFECT.instantiate()
	ghost.set_property(position, sprite.scale, sprite.sprite_frames.get_frame_texture("Idle", sprite.frame))
	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout() -> void:
	add_ghost_effect()

func _bat_death() -> void:
	if hp_component.hp <= 0:
		self.queue_free()
