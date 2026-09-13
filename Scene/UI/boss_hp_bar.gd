extends Control
class_name BossHPBar

const NORMAL_COLOR : Color = "ffffff"
const RAGE_COLOR : Color = "ff6a59"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $Control/TextureRect
@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var boss_name_label: Label = $Control/Label

var target : Character

func _ready() -> void:
	boss_name_label.label_settings.font_color = NORMAL_COLOR

func _process(delta: float) -> void:
	if target == null:
		return
	boss_name_label.text = target.character_name
	progress_bar.max_value = target.hp_component.max_hp
	progress_bar.min_value = 0
	progress_bar.value = target.hp_component.hp

func show_ui() -> void:
	visible = true
	animation_player.play("Start")

func shake() -> void:
	animation_player.play("Hurt")
