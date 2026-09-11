extends Control
class_name ModifierTimer

const PROGRESS_BAR_PURPLE = preload("uid://dj5h3trrmvpsd")
const PROGRESS_BAR_DARK_PURPLE = preload("uid://ctuy4uc0kwl0l")
const PROGRESS_BAR_DARK_RED = preload("uid://d3pyu3kphs1q2")


@onready var progress_bar: ProgressBar = $ProgressBar

var purple : StyleBoxTexture = PROGRESS_BAR_PURPLE
var dark_red : StyleBoxTexture = PROGRESS_BAR_DARK_RED
var dark_purple : StyleBoxTexture = PROGRESS_BAR_DARK_PURPLE

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
			progress_bar.add_theme_stylebox_override("fill", purple)
		elif progress_bar.value / progress_bar.max_value >= 0.2:
			progress_bar.add_theme_stylebox_override("fill", dark_purple)
		else:
			progress_bar.add_theme_stylebox_override("fill", dark_red)

func _on_player_applied_modifier(player : Player) -> void:
	weapon = player.inventory.get_child(0)
	weapon.modifier_count_timer.wait_time = 30
	weapon.modifier_count_timer.start()
