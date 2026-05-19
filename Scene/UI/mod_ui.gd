extends Control
class_name ModUI

@export var mod_resources : Array[ModifierResource]

@onready var center_mod: TextureRect = $Panel/CenterMod
@onready var left_mod: TextureRect = $Panel2/LeftMod
@onready var right_mod: TextureRect = $Panel3/RightMod
@onready var mod_name: Label = $Panel/Panel4/ModName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _texture_update(mod_image : Array[ModifierResource]) -> void:
	center_mod.texture
