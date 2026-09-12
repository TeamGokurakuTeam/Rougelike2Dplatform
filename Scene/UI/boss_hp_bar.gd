extends Control
class_name BossHPBar

const NORMAL_COLOR : Color = "ffffff"
const RAGE_COLOR : Color = "ff6a59"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $Control/TextureRect
@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var boss_name_label: Label = $Control/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Start")
	boss_name_label.label_settings.font_color = NORMAL_COLOR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
