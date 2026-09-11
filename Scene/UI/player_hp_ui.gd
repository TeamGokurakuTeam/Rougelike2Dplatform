extends Control
class_name PlayerHpUI

@onready var background: TextureRect = $Background
@onready var hp_progress_bar: ProgressBar = $Background/HpProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp_label: Label = $Background/HpProgressBar/HPLabel

var player : Player

func _ready() -> void:
	animation_player.play("StartAnim1")

func _process(delta: float) -> void:
	pass

func _on_player_hp_changed() -> void:
	animation_player.play("Damaged")
	hp_progress_bar.value = player.hp_component.hp
	hp_label.text = "HP : " + str(floor(player.hp_component.hp))
