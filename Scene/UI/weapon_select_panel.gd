@tool

extends Panel
class_name WeaponSelectPanel

@export var scroll_duration: float = 4.0
@export var wait_duration: float = 2.0

@export var weapon_resource : Resource
@export var is_lock : bool : 
	set(value) :
		is_lock = value
		locked_label.visible = value
		button.disabled = value
		unlock_title.visible = value
		unlock_explain.visible = value

@onready var weapon_texture_rect: TextureRect = $WeaponTextureRect
@onready var name_label: Label = $Name
@onready var button: Button = $Button
@onready var locked_label: Label = $Button/LockedLabel
@onready var explain: RichTextLabel = $explain
@onready var flavor: Label = $flavor
@onready var unlock_title: Label = $Button/UnlockTitle
@onready var unlock_explain: RichTextLabel = $Button/UnlockExplain

var _tween : Tween

func _ready() -> void:
	if weapon_resource:
		weapon_texture_rect.texture = weapon_resource.Sprite
		name_label.text = weapon_resource.Name
		explain.text = weapon_resource.explanation
		flavor.text = weapon_resource.flavor_text
		unlock_explain.text = weapon_resource.unlock_text
	var bar : VScrollBar = explain.get_v_scroll_bar()
	if bar:
		bar.visible = false
		bar.self_modulate = Color("ffffff00")
		call_deferred("_start_auto_scroll")

func _start_auto_scroll() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween()
	_tween.set_loops()
	
	_tween.tween_callback(func(): explain.scroll_to_line(0))
	_tween.tween_interval(wait_duration)
	
	_tween.tween_method(_scroll_to_ratio, 0.0, 1.0, scroll_duration)
	_tween.tween_interval(wait_duration)
	
	_tween.tween_method(_scroll_to_ratio, 1.0, 0.0, scroll_duration)

func _scroll_to_ratio(ratio: float) -> void:
	var bar : VScrollBar = explain.get_v_scroll_bar()
	if bar == null:
		return
	bar.visible = false
	var max_value: float = bar.max_value - bar.page
	if max_value <= 0.0:
		return
	bar.value = max_value * ratio
