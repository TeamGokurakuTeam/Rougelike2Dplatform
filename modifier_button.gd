extends Control
class_name ModifierButton

@export var mod_resource : ModifierResource
@onready var label: Label = $Button/Label

func setup() -> void:
	label.text = mod_resource.modifier_name
