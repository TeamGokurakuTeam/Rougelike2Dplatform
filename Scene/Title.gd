extends Control
class_name TitleUI

@export var max_value_db : int = 3

@onready var bgm_slider: HSlider = $OptionPanel/Sound/BGMSlider
@onready var se_slider: HSlider = $OptionPanel/Sound/SESlider
@onready var master_slider: HSlider = $OptionPanel/Sound/MasterSlider
@onready var option_panel: Panel = $OptionPanel
@onready var transition: ColorRect = $Transition
@onready var black: ColorRect = $Black
@onready var start: Button = $ButtonContainor/START
@onready var full_screen: CheckButton = $OptionPanel/Sound/Check/FullScreen
@onready var vsync: CheckButton = $OptionPanel/Sound/Check/VSYNC
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var bgm_index : int
var is_open : bool
var option_tween : Tween
var start_tween : Tween

var main_game_scene : PackedScene

func _ready() -> void:
	main_game_scene = load("uid://b4i3w233507yf")
	black.visible = false
	(transition.material as ShaderMaterial).set_shader_parameter("progress", 0.0)
	bgm_index = AudioServer.get_bus_index("BGM")
	bgm_slider.value_changed.connect(_on_bgm_value_changed)
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_index))

func _on_bgm_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(bgm_index, linear_to_db(value))

func _on_option_pressed() -> void:
	if not is_open:
		is_open = true
		if option_tween != null and option_tween.is_running():
			option_tween.kill()
		option_tween = create_tween()
		option_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		option_tween.tween_property(option_panel, "global_position", Vector2(327.0, 11.0), 0.5)
	else:
		is_open = false
		if option_tween.is_running():
			option_tween.kill()
		option_tween = create_tween()
		option_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		option_tween.tween_property(option_panel, "global_position", Vector2(534.0, 11.0), 0.5)

func _on_start_pressed() -> void:
	start.disabled = true
	if start_tween != null and start_tween.is_running():
		start_tween.kill()
	start_tween = create_tween()
	start_tween.parallel()
	start_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	start_tween.tween_property(transition.material, "shader_parameter/progress", 0.49, 0.8)
	start_tween.tween_property(audio_stream_player, "volume_db", -50, 0.5)
	await start_tween.finished
	black.visible = true
	get_tree().change_scene_to_packed(main_game_scene)

func _on_vsync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
