extends FloorProgression
class_name RandomFloorProgression

func start_first_floor() -> void:
	super.start_first_floor()
	room_generator.room_generate(null, _get_current_floor_type())
	main_game_node.current_room = room_generator.lobby_room
	_move_player_to_lobby()

func _on_next_floor_entered() -> void:
	super._on_next_floor_entered()
	await Common.fade_out_to_black(main_game_node.get_tree())
	_move_player_to_origin()
	await main_game_node.get_tree().create_timer(0.5).timeout
	room_generator.clear_rooms()
	room_generator.room_generate(null, _get_current_floor_type())
	_move_player_to_lobby()
	main_game_node.current_room = room_generator.lobby_room
	await Common.fade_in_from_black()

func _get_current_floor_type() -> Variant:
	if current_floor == 1:
		return RoomInfoResource.FloorType.FLOOR1
	elif current_floor == 2:
		return RoomInfoResource.FloorType.FLOOR2
	elif current_floor == 3:
		return RoomInfoResource.FloorType.FLOOR3
	else:
		return [RoomInfoResource.FloorType.FLOOR1, RoomInfoResource.FloorType.FLOOR2].pick_random()

func _move_player_to_origin() -> void:
	if player == null or room_generator.lobby_room == null:
		return
	player.global_position = Vector2.ZERO
