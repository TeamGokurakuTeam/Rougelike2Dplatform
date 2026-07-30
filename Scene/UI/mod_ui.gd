extends Control
class_name ModUI

const MODIFIER_UI_PANEL = preload("uid://eba7bld3s5r6")

@export var mod_resources : Array[ModifierResource]

@onready var mod_name: Label = $Panel4/ModName
@onready var carouse_container: CarouseContainer = $Control/CarouseContainer
@onready var mod_container: Control = $Control/CarouseContainer/ModContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_ui()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func texture_update(player : Player) -> void:
	var mod_res_name : String
	var total_panel_count : int = mod_container.get_child_count()
	var player_mod_size : int = player.mod_resource_ids.size()
	
	if total_panel_count < player_mod_size:
		for i in player_mod_size - total_panel_count:
			var panel : ModifierUIPanel = MODIFIER_UI_PANEL.instantiate()
			mod_container.add_child(panel)
	elif total_panel_count > player_mod_size:
		for i in total_panel_count - player_mod_size:
			mod_container.get_child(total_panel_count - 1 - i).queue_free()
	for i in player_mod_size:
		var panel : ModifierUIPanel = mod_container.get_child(i)
		panel.texture_rect.texture = GlobalResourceLoader.item_cache[player.mod_resource_ids[i]].texture
	
	if player.current_modifier < 0:
		mod_name.text = "なし"
	else:
		mod_res_name = GlobalResourceLoader.item_cache[player.mod_resource_ids[player.current_modifier]].modifier_name
		mod_name.text = mod_res_name
	
	carouse_container.selected_index = player.current_modifier


func init_ui() -> void:
	for node in mod_container.get_children():
		node.queue_free()
	mod_name.text = "なし"

func _on_player_modifier_updated(player : Player) -> void:
	texture_update(player)
	
