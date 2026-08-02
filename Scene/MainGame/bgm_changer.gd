extends Node2D
class_name BGMChanger

@export var stage_bgm : AudioStreamPlayer
@export var battle_bgm : AudioStreamPlayer
@export var boss_bgm : AudioStreamPlayer

var is_mute : bool = false

func _ready() -> void:
	stage_bgm.play()

func change_bgm(currnet_bgm : AudioStreamPlayer, new_bgm : AudioStreamPlayer) -> void:
	await fade_out(currnet_bgm, 1.0)
	fade_in(new_bgm, 1.5)

func fade_out(bgm : AudioStreamPlayer, duration : float) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(bgm, "volume_db", -20, duration)
	await tween.finished
	bgm.stop()

func fade_in(bgm : AudioStreamPlayer, duration : float) -> void:
	bgm.volume_db = -20
	bgm.play()
	var tween : Tween = create_tween()
	tween.tween_property(bgm, "volume_db", 0, duration)
	await tween.finished
