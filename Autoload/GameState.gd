extends Node
class_name GameState

var furthest_clear_floor : int = 0
var found_floor1_secret_room : bool = false
var current_selected_weapon : String = "A_NewWorld"
var is_in_secret_room : bool = false
var has_played_tutorial : bool = false
var is_current_floor_boss_killed : bool = false
var is_cutscene_active : bool = false
var menu_open_count : int = 0
var best_floor_clear_time_list : Dictionary[int, int] = {}
var current_floor_start_tick : int = 0
var has_cleared_1st_floor_with_silver_sword : bool = false
var enemy_2nd_floor_kill_count : int = 0

func menu_opened() -> void:
	menu_open_count += 1

func menu_closed() -> void:
	menu_open_count = max(0, menu_open_count - 1)

func is_menu_active() -> bool:
	return menu_open_count > 0

func can_open_menu() -> bool:
	return not is_cutscene_active and not is_menu_active()

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
