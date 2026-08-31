extends StaticBody2D
class_name Door

@onready var player_detector: Area2D = $PlayerDetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var dir : Direction = Direction.NONE #NONEは初期値用
@export var is_open : bool = false

var current_room : Room
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
		var target_door : Door = teleport_to

		var progression : RandomFloorProgression = main_game_node.floor_progression as RandomFloorProgression
		if progression and progression.current_floor == 1 and \
		   main_game_node.is_killed_floor_boss and not GlobalGameState.found_floor1_secret_room:

			var connect_to_lobby : bool = (
				current_room.room_type == RoomInfoResource.RoomType.LOBBY_ROOM or
				target_door.current_room.room_type == RoomInfoResource.RoomType.LOBBY_ROOM
			) and current_room.room_type != RoomInfoResource.RoomType.SECRET_ROOM

			if connect_to_lobby and randf() < 0.05:
				var secret : Room = main_game_node.room_generator.secret_room
				if secret and secret.doors.get_child_count() > 0:
					target_door = secret.doors.get_child(0)

		await Common.fade_out_to_black(get_tree())

		var player : Player = body as Player
		player.global_position = target_door.exit_point.global_position

		var is_going_in_secret_room : bool = target_door.current_room.room_type == RoomInfoResource.RoomType.SECRET_ROOM
		var is_coming_out_sceret_room : bool = (
			current_room.room_type == RoomInfoResource.RoomType.SECRET_ROOM and
			target_door.current_room.room_type != RoomInfoResource.RoomType.SECRET_ROOM
		)
		if is_going_in_secret_room :
			main_game_node.player_ui.ui_fade_in()
		elif is_coming_out_sceret_room:
			main_game_node.player_ui.ui_fade_out()

		await Common.fade_in_from_black()
		target_door.exit_door_player_entered.emit(player)

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
