extends Node
class_name GameState

var furthest_clear_floor : int = 0
var found_floor1_secret_room : bool = false
var current_selected_weapon : String = "A_NewWorld"
var is_in_secret_room : bool = false
var has_played_tutorial : bool = false
var is_current_floor_boss_killed : bool = false
var best_floor_clear_time_list : Dictionary[int, int] = {}

func record_best_floor_clear_time(floor_number: int):
	var current_tick_time : int = Time.get_ticks_msec()
	if best_floor_clear_time_list.has(floor_number):
		best_floor_clear_time_list[floor_number] = min(
			current_tick_time,
			best_floor_clear_time_list[floor_number]
		)
	else:
		best_floor_clear_time_list[floor_number] = current_tick_time

func get_best_floor_clear_time(floor_number: int) -> int:
	if best_floor_clear_time_list.has(floor_number):
		return best_floor_clear_time_list[floor_number]
	return -1