extends Node
class_name FloorProgression

var main_game_node : MainGame
var room_generator : RoomGenerator
var player : Player
var player_ui : GameUI
var current_floor : int = 1

func start_first_floor() -> void:
	current_floor = 1

func _on_next_floor_entered() -> void:
	current_floor += 1
	GameEvents.floor_changed.emit(current_floor)

func _move_player_to_lobby() -> void:
	if player == null or room_generator.lobby_room == null:
		return
	player.global_position = room_generator.lobby_room.player_marker.global_position