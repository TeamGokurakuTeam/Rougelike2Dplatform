extends Control
class_name WeaponModifierUI

const HIDE_POSITION : Vector2 = Vector2(553.0, 20.0)
const SHOW_POSITION : Vector2 = Vector2(267.0, 20.0)
const TRANSPARENT : Color = Color("ffffff00")
const NORMAL : Color = Color("ffffff")

@export var mod_resources : Array[ModifierResource]
#parent#
@onready var panel: Panel = $Panel
@onready var back_ground: Panel = $BackGround

##Weapon##
@onready var weapon_sprite: TextureRect = $Panel/Weapon/WeaponSprite
@onready var weapon_name: Label = $Panel/Weapon/WeaponName

##ModifierExplanation##
@onready var mod_title: Label = $Panel/ModifierPanel/ModifierExplanation/ModTitle
@onready var setumei: Label = $Panel/ModifierPanel/ModifierExplanation/setumei
@onready var mod_container: VBoxContainer = $Panel/ModifierPanel/ModifierList/ScrollContainer/ModContainer
####

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tween : Tween

func _ready() -> void:
	panel.global_position = HIDE_POSITION
	back_ground.self_modulate = TRANSPARENT

func show_ui() -> void:
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	panel.visible = true
	back_ground.visible = true
	tween.parallel()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	tween.tween_property(back_ground, "self_modulate", NORMAL, 0.6)
	tween.tween_property(panel, "global_position", SHOW_POSITION, 1.0)

func hide_ui() -> void:
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.parallel()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(panel, "global_position", HIDE_POSITION, 1.0)
	tween.tween_property(back_ground, "self_modulate", TRANSPARENT, 0.6)
	await tween.finished
	panel.visible = false
	back_ground.visible = false
