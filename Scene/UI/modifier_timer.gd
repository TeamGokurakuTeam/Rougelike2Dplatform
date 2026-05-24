extends Control
class_name ModifierTimer

@onready var second: Label = $second

var weapon : Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if weapon != null:
		if weapon.modifiers_ids.size() < 0:
			second.text = "?"
		else:
			second.text = str(weapon.modifier_count_timer.time_left)

func _on_player_applied_modifier(player : Player) -> void:
	weapon = player.inventory.get_child(0)
