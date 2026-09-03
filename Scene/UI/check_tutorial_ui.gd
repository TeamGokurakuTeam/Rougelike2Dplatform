extends Control
class_name CheckTutorialUI

@onready var do_it: Button = $Panel/DoIt
@onready var not_doing: Button = $Panel/NotDoing
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var ui_tween : Tween = null

func _ready() -> void:
	animation_player.play("Start")

#region Signal

##ButtonPressed Signal
func _on_not_doing_pressed() -> void:
	animation_player.play("End")

func _on_do_it_pressed() -> void:
	animation_player.play("End")
##

##NotDoingButton Tween Signal
func _on_not_doing_mouse_entered() -> void:
	if ui_tween:
		ui_tween.kill()
	ui_tween = create_tween()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	ui_tween.tween_property(not_doing, "offset_transform_scale", Vector2(1.2, 1.2), 0.5)

func _on_not_doing_mouse_exited() -> void:
	if ui_tween:
		ui_tween.kill()
	ui_tween = create_tween()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	ui_tween.tween_property(not_doing, "offset_transform_scale", Vector2.ONE, 0.5)
##

##DoItButton Tween Signal
func _on_do_it_mouse_entered() -> void:
	if ui_tween:
		ui_tween.kill()
	ui_tween = create_tween()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	ui_tween.tween_property(do_it, "offset_transform_scale", Vector2(1.2, 1.2), 0.5)

func _on_do_it_mouse_exited() -> void:
	if ui_tween:
		ui_tween.kill()
	ui_tween = create_tween()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	ui_tween.tween_property(do_it, "offset_transform_scale", Vector2.ONE, 0.5)
##
#endregion
