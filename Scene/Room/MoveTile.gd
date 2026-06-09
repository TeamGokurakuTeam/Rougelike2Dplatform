extends StaticBody2D
class_name MoveTile

#動きの幅
@export var move_distance : float = 100.0
#スピード
@export var move_speed : float = 1.0
@export var axis : Vector2 = Vector2.RIGHT
@export var disable_time : float = 0.2

@onready var col: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sensor: Area2D = $Sensor

var _start_pos : Vector2
var _move : float = 0.0
var player_inside : bool = false
var player_body : Node2D = null
var current_time : float = 0.0

func _ready() -> void:
	_start_pos = position
	sensor.body_entered.connect(_on_body_entered)
	sensor.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	_move += delta * move_speed
	var offset = axis * move_distance * sin(_move)
	position = _start_pos + offset
	if current_time > 0:
		current_time -= delta
		col.disabled =true
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
	if not body.is_in_group("player"):
		return
	player_inside = true
	player_body = body
	if body.veloctiy.y > 0:
		current_time = disable_time
		col.disabled = true

func _on_body_exited(body : Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = false
	player_body = null
	if current_time <= 0:
		col.disabled = false
