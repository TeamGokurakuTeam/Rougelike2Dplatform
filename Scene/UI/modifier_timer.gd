extends Control
class_name ModifierTimer

@onready var progress_bar: ProgressBar = $ProgressBar

var weapon : Weapon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if weapon != null:
		if weapon.modifiers_ids.size() < 0:
			progress_bar.value = 0
		else:
			progress_bar.max_value = weapon.modifier_count_timer.wait_time
			progress_bar.value = weapon.modifier_count_timer.time_left

func _on_player_applied_modifier(player : Player) -> void:
	weapon = player.inventory.get_child(0)
	weapon.modifier_count_timer.wait_time = 30
	weapon.modifier_count_timer.start()
