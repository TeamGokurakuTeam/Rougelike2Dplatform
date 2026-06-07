extends StaticBody2D

@export var move_distance : float = 100.0
@export var move_speed : float = 1.0
@export var axis : Vector2 = Vector2.RIGHT

var _start_pos : Vector2
var _t : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_pos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_t += delta * move_speed
	var offset = axis * move_distance * sin(_t)
	global_position = _start_pos + offset
