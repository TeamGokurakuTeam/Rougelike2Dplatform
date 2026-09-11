extends Node
class_name GameState

var furthest_clear_floor : int = 0
var found_floor1_secret_room : bool = false
var current_selected_weapon : String = "A_NewWorld"
var is_in_secret_room : bool = false
var has_played_tutorial : bool = false
var is_current_floor_boss_killed : bool = false
var best_floor_clear_time_list : Dictionary[int, int] = {}
var current_floor_start_tick : int = 0

func start_floor_timer() -> void:
	current_floor_start_tick = Time.get_ticks_msec()

func record_best_floor_clear_time(floor_number: int):
	var elapsed_time : int = Time.get_ticks_msec() - current_floor_start_tick
	if best_floor_clear_time_list.has(floor_number):
		best_floor_clear_time_list[floor_number] = min(
			elapsed_time,
			best_floor_clear_time_list[floor_number]
		)
	else:
		best_floor_clear_time_list[floor_number] = elapsed_time

func get_best_floor_clear_time(floor_number: int) -> int:
	if best_floor_clear_time_list.has(floor_number):
		return best_floor_clear_time_list[floor_number]
	return -1
