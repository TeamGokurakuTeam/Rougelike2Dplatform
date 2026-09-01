extends StaticBody2D
class_name Door

@onready var player_detector: Area2D = $PlayerDetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var dir : Direction = Direction.NONE #NONEは初期値用
@export var is_open : bool = false

var teleport_to : Door
var exit_point : Marker2D
var main_game_node : MainGame

signal exit_door_player_entered(player : Player)

enum Direction {
	NONE,
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

func _ready() -> void:
	exit_point = get_node("./ExitPoint")
	if is_open:
		open()

func open() -> void:
	animation_player.play("Open")

func lock() -> void:
	animation_player.play("Lock")

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player and teleport_to != null:
		await Common.fade_out_to_black(get_tree())
		var player : Player = body as Player
		player.global_position = teleport_to.exit_point.global_position
		await Common.fade_in_from_black()
		teleport_to.exit_door_player_entered.emit(player)

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
