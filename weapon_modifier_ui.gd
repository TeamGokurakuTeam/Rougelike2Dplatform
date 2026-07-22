extends Control
class_name WeaponModifierUI

const HIDE_POSITION : Vector2 = Vector2(553.0, 20.0)
const SHOW_POSITION : Vector2 = Vector2(267.0, 20.0)
const TRANSPARENT : Color = Color("ffffff00")
const NORMAL : Color = Color("ffffff")
const MODIFIER_BUTTON = preload("uid://c03a0ku5ghb2a")
const LOCK_MODIFIER_BUTTON = preload("uid://dchcs7a330j1m")

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
@onready var mod_explanation: RichTextLabel = $Panel/ModifierPanel/ModifierExplanation/ModExplanation
####

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tween : Tween

func init_ui() -> void:
	mod_title.text = ""
	mod_explanation.text = ""
	weapon_name.text = ""
	weapon_sprite.texture = null

func load_modifier(player : Player) -> void:
	for node in mod_container.get_children():
		node.queue_free()
	if player == null or player.weapon == null:
		return
	
	var modifier_ids : Array[String] = []
	var lock_modifier_ids : Array[String] = []
	
	for mod in player.weapon.lock_modifiers_ids.keys():
		lock_modifier_ids.append(mod)
	for mod in player.weapon.modifiers_ids.keys():
		if not modifier_ids.has(mod):
			modifier_ids.append(mod)
	
	for mod in lock_modifier_ids:
		var lock_mod_button : ModifierButton = LOCK_MODIFIER_BUTTON.instantiate()
		mod_container.add_child(lock_mod_button)
		lock_mod_button.setup(mod, self, player.weapon.get_modifiers_level(mod))
	for mod in modifier_ids:
		var mod_button : ModifierButton = LOCK_MODIFIER_BUTTON.instantiate()
		mod_container.add_child(mod_button)
		mod_button.setup(mod, self, player.weapon.get_modifiers_level(mod))
	
	weapon_sprite.texture = player.weapon.sprite_2d.texture
	weapon_name.text = (GlobalResourceLoader.item_cache[player.weapon.resource_id] as ResourceItem).Name

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

func update_explanation_ui(mod : ModifierResource, count : int) -> void:
	if mod == null:
		mod_title.text = ""
		mod_explanation.text = ""
		return
	if count > 1:
		mod_title.text = mod.modifier_name + " : Lv " + str(count)
	else:
		mod_title.text = mod.modifier_name
	mod_explanation.text = mod.explanation
