extends Control
class_name ModifierTimer

const PROGRESS_BAR_GREEN = preload("uid://811t80uoagdn")
const PROGRESS_BAR_RED = preload("uid://bpipwe4a2tnnc")
const PROGRESS_BAR_YELLOW = preload("uid://cmtakuxgimwgs")

@onready var progress_bar: ProgressBar = $ProgressBar

var green : StyleBoxFlat = PROGRESS_BAR_GREEN
var red : StyleBoxFlat = PROGRESS_BAR_RED
var yellow : StyleBoxFlat = PROGRESS_BAR_YELLOW

var weapon : Weapon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if weapon != null:
		if weapon.modifiers_ids.size() < 0:
			progress_bar.value = 0
		else:
			progress_bar.max_value = weapon.modifier_count_timer.wait_time
			progress_bar.value = weapon.modifier_count_timer.time_left
			
		if progress_bar.value / progress_bar.max_value >= 0.5:
			progress_bar.add_theme_stylebox_override("fill", green)
		elif progress_bar.value / progress_bar.max_value >= 0.2:
			progress_bar.add_theme_stylebox_override("fill", yellow)
		else:
			progress_bar.add_theme_stylebox_override("fill", red)

func _on_player_applied_modifier(player : Player) -> void:
	weapon = player.inventory.get_child(0)
	weapon.modifier_count_timer.wait_time = 30
	weapon.modifier_count_timer.start()
