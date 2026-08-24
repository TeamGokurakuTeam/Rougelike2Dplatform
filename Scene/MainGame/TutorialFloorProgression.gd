extends FloorProgression
class_name TutorialFloorProgression

@export var tutorial_floor_layout : FloorLayoutResource
@export var main_game_scene : PackedScene

func start_first_floor() -> void:
	room_generator.room_generate(tutorial_floor_layout)
	main_game_node.current_room = room_generator.lobby_room
	_move_player_to_lobby()

func _on_next_floor_entered() -> void:
	await Common.fade_out_to_black(main_game_node.get_tree())
	main_game_node.get_tree().change_scene_to_packed(main_game_scene)