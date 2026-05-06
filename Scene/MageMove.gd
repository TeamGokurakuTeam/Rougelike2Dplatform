extends State
class_name MageMove

@export var animation_player : AnimationPlayer
@export var parent : Mage
@export var sprite: AnimatedSprite2D
@export var spell_timer: Timer

const KEEP_DISTANCE := 300.0
const SPELL_INTERVAL := 3.0
var player : Player
var dist :=0.0

func Enter() -> void:
	animation_player.play("Move")
	if get_tree().get_node_count_in_group("Player") > 0:
		player = get_tree().get_nodes_in_group("Player")[0]
	if spell_timer:
		spell_timer.start()


func Exit() -> void:
	if spell_timer:
		spell_timer.stop()

func Physics_Update(delta) -> void:
	if not player:
		return
	dist = parent.global_position.distance_to(player.global_position)
	parent.velocity += parent.get_gravity() * delta
	if dist < KEEP_DISTANCE:
		move_away_from_player()
	else:
		set_target(player.global_position)
		move_toward_player()
	func_player()
	parent.move_and_slide()

func set_target(target_pos : Vector2) -> void:
	parent.navigation_agent_2d.target_position = target_pos

func move_toward_player() -> void:
	if parent.navigation_agent_2d.is_navigation_finished():
		return
	var next_pos : Vector2 = parent.navigation_agent_2d.get_next_path_position()
	var dir : Vector2 = (next_pos - parent.global_position).normalized()
	parent.velocity.x = dir.x * parent.SPEED
	if dir.y < -0.9 and parent.is_on_floor():
		parent.velocity.y = parent.JUMP_VELOCITY

func move_away_from_player() -> void:
	var dir := (parent.global_position - player.global_position).normalized()
	parent.velocity.x = dir.x * parent.SPEED
	if dir.y < -0.9 and parent.is_on_floor():
		parent.velocity.y = parent.JUMP_VELOCITY

func func_player() -> void:
	if not player:
		return
	if player.global_position.x > parent.global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func _on_cool_down_timeout() -> void:
	StateTransitioned.emit(self , "Spell")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		if randf() < 0.5:
			StateTransitioned.emit(self, "MagicAttack")
		else:
			StateTransitioned.emit(self, "Teleport")
