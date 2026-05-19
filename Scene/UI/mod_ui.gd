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
	pass

func _on_player_pickup_modifier(player : Player) -> void:
	var prev_texture : Texture
	var texture : Texture
	var next_texture : Texture
	if player.mod_resource_ids.size() <= 0:
		return
	elif player.mod_resource_ids.size() == 1:
		texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[player.current_modifier]].texture
		center_mod.texture = texture
		left_mod.texture = texture
		right_mod.texture = texture
	elif player.mod_resource_ids.size() == 2:
		var current_number : int = player.current_modifier
		var prev_number : int = 0 if player.current_modifier == 1 else 1
		texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[current_number]].texture
		prev_texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[prev_number]].texture
		center_mod.texture = prev_texture
		left_mod.texture = texture
		right_mod.texture = prev_texture
	elif player.mod_resource_ids.size() >= 3:
		var prev_number : int = (player.current_modifier - 1) % 3
		var current_number : int = player.current_modifier
		var next_number : int = (player.current_modifier + 1) % 3
		
		center_mod.texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[current_number]].texture
		left_mod.texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[prev_number]].texture
		right_mod.texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[next_number]].texture
	
	
