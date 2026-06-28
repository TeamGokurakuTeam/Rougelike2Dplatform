extends Control
class_name RiskReturnUI

@onready var back_ground: Panel = $BackGround
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player : Player


func _ready() -> void:
	for node in back_ground.get_children():
		var panel : RiskReturnPanel = node as RiskReturnPanel
		panel.setup("FixedModifier")
		panel.button.button_down.connect(_on_button_pressed)
	animation_player.play("Ready")

func _on_button_pressed() -> void:
	player = get_tree().get_first_node_in_group("Player")
	var weapon : Weapon = player.weapon
	var id : String = player.mod_resource_ids.pick_random()
	weapon.decrease_modifier(id)
	weapon.add_lock_modifier(id)
	print(id)
	animation_player.play("End")
