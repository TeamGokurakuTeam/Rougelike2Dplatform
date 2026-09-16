extends Control
class_name TitleUI

const WEAPON_SELECT_MENU = preload("uid://crrgxcmvwd3d6")

@export var max_value_db : int = 3

@onready var bgm_slider: HSlider = $OptionPanel/Sound/BGMSlider
@onready var se_slider: HSlider = $OptionPanel/Sound/SESlider
@onready var master_slider: HSlider = $OptionPanel/Sound/MasterSlider
@onready var option_panel: Panel = $OptionPanel
@onready var transition: ColorRect = $Transition
@onready var black: ColorRect = $Black
@onready var full_screen: CheckButton = $OptionPanel/Sound/Check/FullScreen
@onready var vsync: CheckButton = $OptionPanel/Sound/Check/VSYNC
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var start: Button = $ButtonContainor/START
@onready var option: Button = $ButtonContainor/OPTION
@onready var quit: Button = $ButtonContainor/QUIT

var bgm_index : int
var se_index : int
var master_index : int

var is_open : bool
var option_tween : Tween
var start_tween : Tween

func _ready() -> void:
	InputDeviceManager.device_changed.connect(_on_device_changed)
	if InputDeviceManager.current_input_mode == InputDeviceManager.InputMode.CONTROLLER:
		start.grab_focus()
	black.visible = false
	option_panel.visible = false
	(transition.material as ShaderMaterial).set_shader_parameter("progress", 0.0)
	bgm_index = AudioServer.get_bus_index("BGM")
	se_index = AudioServer.get_bus_index("SoundEffect")
	master_index = AudioServer.get_bus_index("Master")
	bgm_slider.value_changed.connect(_on_bgm_value_changed)
	se_slider.value_changed.connect(_on_se_value_changed)
	master_slider.value_changed.connect(_on_master_value_changed)
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_index))
	se_slider.value = db_to_linear(AudioServer.get_bus_volume_db(se_index))
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))

func _on_bgm_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(bgm_index, linear_to_db(value))

func _on_se_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(se_index, linear_to_db(value))

func _on_master_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))

func _on_option_pressed() -> void:
	if not is_open:
		is_open = true
		if option_tween != null and option_tween.is_running():
			option_tween.kill()
		option_panel.visible = is_open
		option_tween = create_tween()
		option_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		option_tween.tween_property(option_panel, "global_position", Vector2(327.0, 11.0), 0.5)
	else:
		is_open = false
		if option_tween.is_running():
			option_tween.kill()
		option_panel.visible = is_open
		option_tween = create_tween()
		option_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		option_tween.tween_property(option_panel, "global_position", Vector2(534.0, 11.0), 0.5)

func _on_start_pressed() -> void:
	_start_tween_transition()
	var weapon_select_menu : WeaponSelectMenu = WEAPON_SELECT_MENU.instantiate()
	weapon_select_menu.title = self
	get_tree().current_scene.add_child(weapon_select_menu)
	visible_button()
	#get_tree().change_scene_to_packed(main_game_scene)

func _end_tween_transition() -> void:
	start.disabled = false
	(transition.material as ShaderMaterial).set_shader_parameter("progress", 0.0)
	if start_tween.is_running() or start_tween != null:
		start_tween.kill()
	black.visible = false
	start_tween = create_tween()
	start_tween.parallel()
	start_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	start_tween.tween_property(transition.material, "shader_parameter/progress", 1.0, 0.8)
	await start_tween.finished

func _start_tween_transition() -> void:
	start.disabled = true
	if start_tween != null and start_tween.is_running():
		start_tween.kill()
	start_tween = create_tween()
	start_tween.parallel()
	start_tween.tween_property(transition.material, "shader_parameter/progress", 0.49, 0.8)
	await start_tween.finished
	black.visible = true

func visible_button() -> void:
	start.visible = !start.visible
	option.visible = !option.visible
	quit.visible = !quit.visible

func _on_device_changed(input_mode : InputDeviceManager.InputMode) -> void:
	if input_mode == InputDeviceManager.InputMode.CONTROLLER:
		if get_viewport().gui_get_focus_owner() == null:
			start.grab_focus()
	else:
		# マウス操作に戻ったら、コントローラー用のフォーカス枠を消す
		var focused := get_viewport().gui_get_focus_owner()
		if focused:
			focused.release_focus()

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

func _on_quit_pressed() -> void:
	get_tree().quit()
