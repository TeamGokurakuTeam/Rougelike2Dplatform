extends CanvasLayer
class_name GameUI

const TITLE = preload("uid://d15a301cfnn87")
const MAIN_GAME = preload("uid://b4i3w233507yf")
const SHOP_UI = preload("uid://ck5n0v7vducof")
const PAUSE_MENU = preload("uid://bi80dehen74u6")

@onready var hotbar: HBoxContainer = $Parent/Hotbar
@onready var mod_ui: ModUI = $Parent/ModUI
@onready var modifier_timer: ModifierTimer = $Parent/ModifierTimer
@onready var player_hp_ui: PlayerHpUI = $Parent/PlayerHpUI
@onready var locked_mod_label: Label = $Parent/LockedModLabel
@onready var modifier_explanation: ModifierExplanationUI = $Parent/ModifierExplanation
@onready var parent: Control = $Parent
@onready var weapon_modifier_ui: WeaponModifierUI = $WeaponModifierUI
@onready var game_over_animation_player: AnimationPlayer = $GameOver/AnimationPlayer
@onready var retry: Button = $GameOver/Retry
@onready var title: Button = $GameOver/Title
@onready var game_over_panel: Panel = $GameOver

@onready var open_sound: AudioStreamPlayer = $OpenSound
@onready var click_sound: AudioStreamPlayer = $ClickSound

var player : Player
var merchant : MerchantFrog

var fade_tween : Tween

var is_show_mod_ui : bool = false
var is_paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_panel.visible = false
	GameEvents.shop_ui_opened.connect(_on_shop_ui_opened)
	GameEvents.shop_ui_closed.connect(_on_shop_ui_closed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null:
		return
	if Input.is_action_just_pressed("UI_Paused") and not is_paused:
		is_paused = true
		get_tree().paused = true
		var pause_menu : PauseMenuUI = PAUSE_MENU.instantiate()
		pause_menu.player_ui = self
		add_child(pause_menu)
	if Input.is_action_just_pressed("UI_scroll_left"):
		player.current_modifier += 1
		mod_ui.texture_update(player)
	if Input.is_action_just_pressed("UI_scroll_right"):
		player.current_modifier -= 1
		mod_ui.texture_update(player)
	if Input.is_action_just_pressed("UI_ShowMod"):
		is_show_mod_ui = !is_show_mod_ui
		open_sound.play()
		if is_show_mod_ui:
			weapon_modifier_ui.init_ui()
			weapon_modifier_ui.load_modifier(player)
			weapon_modifier_ui.show_ui()
		else:
			weapon_modifier_ui.hide_ui()

func _on_character_modifier_updated(player: Player) -> void:
	for i in hotbar.get_children().size():
		var node : InventoryPanel = hotbar.get_child(i)
		if i >= player.weapon_resource_ids.size() or i < 0:
			node.resource = null
		else:
			var resource : ResourceItem = GlobalResourceLoader.weapon_cache[player.weapon_resource_ids[i]]
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

func ui_fade_in() -> void:
	if fade_tween != null and fade_tween.is_running():
		fade_tween.kill()
	fade_tween = create_tween()
	parent.modulate = Color("ffffff")
	fade_tween.tween_property(parent, "modulate", Color("ffffff00"), 1.0)
	fade_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await fade_tween.finished

func ui_fade_out() -> void:
	if fade_tween != null and fade_tween.is_running():
		fade_tween.kill()
	fade_tween = create_tween()
	parent.modulate = Color("ffffff00")
	fade_tween.tween_property(parent, "modulate", Color("ffffff"), 1.0)
	fade_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await fade_tween.finished

func _on_shop_ui_opened(npc : MerchantFrog) -> void:
	merchant = npc
	ui_fade_in()
	GameEvents.cutscene_started.emit()
	var shop_ui : ShopUI = SHOP_UI.instantiate()
	shop_ui.npc = npc
	add_child(shop_ui)

func _on_shop_ui_closed() -> void:
	merchant.is_running = false
	ui_fade_out()
	GameEvents.cutscene_ended.emit()

func game_over() -> void:
	game_over_panel.visible = true
	player.input_enabled = false
	game_over_animation_player.play("Start")
	await game_over_animation_player.animation_finished
	retry.disabled = false
	title.disabled = false

func _on_retry_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_packed(MAIN_GAME)

func _on_title_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_packed(TITLE)
