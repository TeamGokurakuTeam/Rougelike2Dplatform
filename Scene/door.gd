extends StaticBody2D
class_name Door

@onready var player_detector: CollisionShape2D = $PlayerDetector/CollisionShape2D

@export var dir : Direction = Direction.NONE #NONEは初期値用

var teleport_to : Door
var exit_point : Marker2D

enum Direction {
	NONE,
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

func _ready() -> void:
	exit_point = get_node("./ExitPoint")
	

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player and teleport_to != null:
		var player : Player = body as Player
		player.global_position = teleport_to.exit_point.global_position

static func get_opposite_dirction(dir : Direction) -> Direction:
	match dir:
		Direction.UP:
			dir = Direction.DOWN
		Direction.DOWN:
			dir = Direction.UP
		Direction.LEFT:
			dir = Direction.RIGHT
		Direction.RIGHT:
			dir = Direction.LEFT
	return dir

static func connect_door(door_a : Door, door_b : Door) -> void:
	if door_a == null or door_b == null:
		return
	door_a.teleport_to = door_b
	door_b.teleport_to = door_a
