extends Control
class_name TitleUI

@onready var bgm_slider: HSlider = $OptionPanel/Sound/BGMSlider
@onready var se_slider: HSlider = $OptionPanel/Sound/SESlider
@onready var master_slider: HSlider = $OptionPanel/Sound/MasterSlider

var bgm_index : int

func _ready() -> void:
	bgm_index = AudioServer.get_bus_index("BGM")
	bgm_slider.value_changed.connect(_on_bgm_value_changed)
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_index))

func _on_bgm_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(bgm_index, linear_to_db(value))
