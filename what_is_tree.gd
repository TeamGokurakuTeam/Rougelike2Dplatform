extends Node2D
class_name WhatIsTree

@export_multiline() var text : String

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var key_s_sprite: Sprite2D = $S
@onready var sound: AudioStreamPlayer = $Sound

var text_ratio_tween : Tween
var is_player_inside : bool = false
var is_talked : bool = false

func _ready() -> void:
	visible_off()
	key_s_sprite.visible = false
	rich_text_label.text = ""

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Down") and is_player_inside and not is_talked:
		is_talked = true
		key_s_sprite.visible = false
		visible_on()
		await submit(text, 15.0)
		visible_off()

func visible_on() -> void:
	rich_text_label.visible = true

func visible_off() -> void:
	rich_text_label.visible = false

func submit(text : String, scroll_second : float):
	#count += 1
	rich_text_label.visible_ratio = 0.0
	if text_ratio_tween != null:
		text_ratio_tween.kill()
	text_ratio_tween = create_tween()
	text_ratio_tween.tween_property(rich_text_label, "visible_ratio", 1.0, scroll_second + 1.0)
	rich_text_label.clear()
	rich_text_label.add_text(text)
	rich_text_label.newline()
	# これがないと一度に10行程度入力した時に最下行までスクロールしません
	rich_text_label.get_line_count()
	var bar : VScrollBar = rich_text_label.get_v_scroll_bar()
	bar.modulate = Color("ffffff00")
	await text_ratio_tween.finished
	await get_tree().create_timer(3.0).timeout
	GlobalGameState.found_floor1_secret_room = true
	sound.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not is_talked:
		is_player_inside = true
		key_s_sprite.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_inside = false
		key_s_sprite.visible = false
