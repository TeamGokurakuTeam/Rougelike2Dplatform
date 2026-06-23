extends StaticBody2D
class_name MoveTile

#OneWayの時間
@export var disable_time : float = 0.2
#スピード
@export var move_speed : float = 1.0
@onready var col: CollisionShape2D = $CollisionShape2D
@onready var sensor: Area2D = $Sensor
@onready var line: Line2D = $Line2D

var player_inside : bool = false
var player_body : Node2D = null
var current_time : float = 0.0
var points: Array[Vector2] = []
var current_index: int = 0
var next_index: int = 1
var point_number: float = 0.0
var forward: bool = true
#慣性
var last_position: Vector2
var floor_motion: Vector2 = Vector2.ZERO

func _ready() -> void:
	#慣性
	last_position = global_position
	points =[]
	for p in line.points:
		points.append(line.to_global(p))
	sensor.body_entered.connect(_on_body_entered)
	sensor.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	var prev_pos = global_position
	_move_along_line(delta)
	floor_motion = global_position - prev_pos
	#慣性
	if player_inside and player_body:
		player_body.floor_motion = floor_motion

func _move_along_line(delta: float) -> void:
	if points.size() < 2:
		return
	point_number += delta * move_speed
	while  point_number >= 1.0:
		point_number -= 1.0
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
	var p1 = points[current_index]
	var p2 = points[next_index]
	var eased_point_number := ease(point_number, 1.0)
	position = p1.lerp(p2, eased_point_number)
	if current_time > 0:
		current_time -= delta
		col.disabled = true
		return
	if player_inside and player_body:
		var py = player_body.global_position.y
		var platform_top = global_position.y - col.shape.extents.y
		if py < platform_top:
			col.disabled = false
		else:
			col.disabled = true
	else:
		col.disabled = false

func _on_body_entered(body : Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	player_inside = true
	player_body = body

func _on_body_exited(body : Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	player_inside = false
	player_body = null
	if current_time <= 0:
		col.disabled = false
