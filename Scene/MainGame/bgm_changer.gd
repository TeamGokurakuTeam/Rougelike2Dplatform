extends Node2D
class_name BGMChanger

enum BGMType{
	STAGE,
	BATTLE,
	BOSS
}

@export var stage_bgm : AudioStreamPlayer
@export var battle_bgm : AudioStreamPlayer
@export var boss_bgm : AudioStreamPlayer
@export var currnet_bgm_type : BGMType = BGMType.STAGE

var is_mute : bool = false

func _ready() -> void:
	change_bgm(currnet_bgm_type)

func change_bgm(new_bgm_type : BGMType) -> void:
	var current_bgm : AudioStreamPlayer = bgmtype_to_audiostreamplayer(currnet_bgm_type)
	var new_bgm : AudioStreamPlayer = bgmtype_to_audiostreamplayer(new_bgm_type)
	if current_bgm == null or new_bgm == null:
		return
	currnet_bgm_type = new_bgm_type
	await fade_out(current_bgm, 1.0)
	fade_in(new_bgm, 1.5)

func fade_out(bgm : AudioStreamPlayer, duration : float) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(bgm, "volume_db", -80, duration)
	await tween.finished
	bgm.stop()

func fade_in(bgm : AudioStreamPlayer, duration : float) -> void:
	bgm.volume_db = -20
	bgm.play()
	var tween : Tween = create_tween()
	tween.tween_property(bgm, "volume_db", -25, duration)
	await tween.finished

func bgmtype_to_audiostreamplayer(type : BGMType) -> AudioStreamPlayer:
	match type:
		BGMType.STAGE:
			return stage_bgm
		BGMType.BATTLE:
			return battle_bgm
		BGMType.BOSS:
			return boss_bgm
		_:
			print("BGMTYPEの変換中に例外処理に入りました")
			return null
