extends TileMapLayer
class_name MoveDecoTileMap

@export var MinX : float = -10.0
@export var MaxX : float = 10.0
@export var MinY : float = -10.0
@export var MaxY : float = 10.0
@export var MoveDecoSpeed : float = 5.0

var _origin_position : Vector2
var _target_position : Vector2

func _ready() -> void:
	_origin_position = position
	_set_random_target()

func _process(delta: float) -> void:
	position = position.move_toward(
		_target_position,
		MoveDecoSpeed * delta
	)

	if position == _target_position:
		_set_random_target()

func _set_random_target() -> void:
	_target_position = _origin_position + Vector2(
		randf_range(MinX, MaxX),
		randf_range(MinY, MaxY)
	)
