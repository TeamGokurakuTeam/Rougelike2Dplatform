@tool

extends Panel
class_name WeaponSelectPanel

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

func _ready() -> void:
	if weapon_resource:
		weapon_texture_rect.texture = weapon_resource.Sprite
		name_label.text = weapon_resource.Name
		explain.text = weapon_resource.explanation
		flavor.text = weapon_resource.flavor_text
		unlock_explain.text = weapon_resource.unlock_text
