extends Control
class_name ModUI

@export var mod_resources : Array[ModifierResource]

@onready var center_mod: TextureRect = $Panel/CenterMod
@onready var left_mod: TextureRect = $Panel2/LeftMod
@onready var right_mod: TextureRect = $Panel3/RightMod
@onready var mod_name: Label = $Panel/Panel4/ModName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func texture_update(player : Player) -> void:
	var mod_res_name : String
	var prev_texture : Texture
	var texture : Texture
	var next_texture : Texture
	if player.mod_resource_ids.size() <= 0:
		init_ui()
		return
	elif player.mod_resource_ids.size() == 1:
		texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[player.current_modifier]].texture
		
		center_mod.texture = texture
		left_mod.texture = texture
		right_mod.texture = texture
	elif player.mod_resource_ids.size() == 2:
		var current_number : int = player.current_modifier
		var prev_number : int = player.current_modifier % 2
		
		texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[current_number]].texture
		prev_texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[prev_number]].texture
		
		center_mod.texture = texture
		left_mod.texture = prev_texture
		right_mod.texture = prev_texture
	elif player.mod_resource_ids.size() >= 3:
		var prev_number : int = (player.current_modifier - 1) % player.mod_resource_ids.size()
		var current_number : int = player.current_modifier
		var next_number : int = (player.current_modifier + 1) % player.mod_resource_ids.size()
		
		prev_texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[current_number]].texture
		texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[prev_number]].texture
		next_texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[next_number]].texture
		
		center_mod.texture = texture
		left_mod.texture = prev_texture
		right_mod.texture = next_texture
	mod_res_name = GlobalResourceLoader.item_cache[player.mod_resource_ids[player.current_modifier]].modifier_name
	mod_name.text = mod_res_name

func init_ui() -> void:
	mod_name.text = "なし"
	center_mod.texture = null
	left_mod.texture = null
	right_mod.texture = null

func _on_player_pickup_modifier(player : Player) -> void:
	texture_update(player)
	
