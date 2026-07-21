extends Control
class_name ModifierButton

@onready var label: Label = $Button/Label
@onready var button: Button = $Button

var modifier_resource : ModifierResource
var weapon_modifier_ui : WeaponModifierUI
var modifier_count : int

func setup(mod_resource_id : String, mod_ui : WeaponModifierUI, mod_count : int) -> void:
	weapon_modifier_ui = mod_ui
	modifier_count = mod_count
	modifier_resource = GlobalResourceLoader.item_cache[mod_resource_id]
	label.text = modifier_resource.modifier_name
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	weapon_modifier_ui.update_explanation_ui(modifier_resource, modifier_count)
