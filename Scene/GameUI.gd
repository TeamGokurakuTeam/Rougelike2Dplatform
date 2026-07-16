extends CanvasLayer
class_name GameUI

@onready var hotbar: HBoxContainer = $Parent/Hotbar
@onready var mod_ui: ModUI = $Parent/ModUI
@onready var modifier_timer: ModifierTimer = $Parent/ModifierTimer
@onready var player_hp_ui: PlayerHpUI = $Parent/PlayerHpUI
@onready var locked_mod_label: Label = $Parent/LockedModLabel
@onready var modifier_explanation: ModifierExplanationUI = $Parent/ModifierExplanation
@onready var transition: ColorRect = $Parent/Transition
@onready var parent: Control = $Parent
@onready var weapon_modifier_ui: WeaponModifierUI = $WeaponModifierUI

var player : Player

var tween : Tween
var fade_tween : Tween

var is_show_mod_ui : bool = false

signal attribute_ui_triggered(player : Player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_scroll_left"):
		player.current_modifier += 1
		mod_ui.texture_update(player)
	if Input.is_action_just_pressed("UI_scroll_right"):
		player.current_modifier -= 1
		mod_ui.texture_update(player)
	if Input.is_action_just_pressed("UI_ShowMod"):
		attribute_ui_triggered.emit(player)

func _on_character_modifier_updated(player: Player) -> void:
	for i in hotbar.get_children().size():
		var node : InventoryPanel = hotbar.get_child(i)
		if i >= player.weapon_resource_ids.size() or i < 0:
			node.resource = null
		else:
			var resource : ResourceItem = GlobalResourceLoader.item_cache[player.weapon_resource_ids[i]]
			node.resource = resource
		node.update(player.current_weapon == i)

func _on_modifier_picked_up(mod_res : ModifierResource) -> void:
	modifier_explanation.modifier_resource = mod_res
	modifier_explanation.texture_rect.texture = mod_res.texture
	modifier_explanation.submit(mod_res.explanation, 5.0)
	if modifier_explanation.animation_player.is_playing():
		modifier_explanation.animation_player.play("Normal")
	else:
		modifier_explanation.animation_player.play("Start")
	await modifier_explanation.animation_player.animation_finished
	modifier_explanation.animation_player.play("End")

func transition_start() -> void:
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	(transition.material as ShaderMaterial).set_shader_parameter("progress", .0)
	tween.tween_property(transition.material, "shader_parameter/progress", 1.0, 0.8)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

func transition_back() -> void:
	(transition.material as ShaderMaterial).set_shader_parameter("progress", 1.0)
	if tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(transition.material, "shader_parameter/progress", .0, 0.8)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func ui_fade_in() -> void:
	if fade_tween != null and fade_tween.is_running():
		fade_tween.kill()
	fade_tween = create_tween()
	parent.modulate = Color("ffffff")
	fade_tween.tween_property(parent, "modulate", Color("ffffff00"), 1.0)
	fade_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func ui_fade_out() -> void:
	if fade_tween != null and fade_tween.is_running():
		fade_tween.kill()
	fade_tween = create_tween()
	parent.modulate = Color("ffffff00")
	fade_tween.tween_property(parent, "modulate", Color("ffffff"), 1.0)
	fade_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
