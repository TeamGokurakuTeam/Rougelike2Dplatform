extends OneWayPlatform
class_name MoveTile

@export var disable_time : float = 0.2
@export var move_speed : float = 1.0

@onready var line: Line2D = $Line2D

var current_time : float = 0.0
var points: Array[Vector2] = []
var current_index: int = 0
var next_index: int = 1
var trail_progress: float = 0.0
var forward: bool = true
var last_position: Vector2

func _ready() -> void:
	last_position = global_position
	for p in line.points:
		points.append(line.to_global(p))
	super()

func _physics_process(delta: float) -> void:
	var prev_pos : Vector2 = global_position
	_move_along_line(delta)
	var floor_motion : Vector2 = global_position - prev_pos
	if player_inside and player_body:
		player_body.global_position += floor_motion
	_update_collision(delta)
	_handle_pass_through_input()

func _move_along_line(delta: float) -> void:
	if points.size() < 2:
		return
	_move_progress(delta)
	var p1 : Vector2 = points[current_index]
	var p2 : Vector2 = points[next_index]
	var eased_progress := ease(trail_progress, 1.0)
	position = p1.lerp(p2, eased_progress)

func _move_progress(delta: float) -> void:
	trail_progress += delta * move_speed
	while trail_progress >= 1.0:
		trail_progress -= 1.0
		if forward:
			current_index += 1
			if current_index >= points.size() - 1:
				current_index = points.size() - 1
				forward = false
		else:
			current_index -= 1
			if current_index <= 0:
				current_index = 0
				forward = true
	next_index = current_index + (1 if forward else -1)

func _update_collision(delta: float) -> void:
	if current_time > 0:
		current_time -= delta
		col.disabled = true
		return
	super(delta)

func _on_body_exited(body : Node2D) -> void:
	if body is Player:
		player_inside = false
		player_body = null
		player_touching = false
		if current_time <= 0:
			col.disabled = false
