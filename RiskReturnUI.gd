extends Control
class_name RiskReturnUI

@onready var center_button: Button = $BackGround/CenterPanel/CenterButton
@onready var left_button: Button = $BackGround/LeftPanel/LeftButton
@onready var right_button: Button = $BackGround/RightPanel/RightButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player : Player

func _ready() -> void:
	animation_player.play("Ready")

func _on_right_button_pressed() -> void:
	player = get_tree().get_first_node_in_group("Player")
	var weapon : Weapon = player.weapon
	weapon.add_lock_modifier("Bloodletting")
	animation_player.play("End")

func _on_center_button_pressed() -> void:
	pass # Replace with function body.

func _on_left_button_pressed() -> void:
	pass # Replace with function body.
