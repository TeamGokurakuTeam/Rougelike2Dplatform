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
	var dissolving_index : int = -1
	for i in mod_container.get_child_count():
		var child = mod_container.get_child(i)
		if child is ModifierUIPanel and child.is_dissolving:
			dissolving_index = i
			break
	
	var mod_res_name : String
	var total_panel_count : int = mod_container.get_child_count()
	var player_mod_size : int = player.mod_resource_ids.size()

	var expected_panel_count :int = player_mod_size
	if dissolving_index != -1:
		expected_panel_count += 1

	if total_panel_count < expected_panel_count:
		for i in expected_panel_count - total_panel_count:
			var panel : ModifierUIPanel = MODIFIER_UI_PANEL.instantiate()
			mod_container.add_child(panel)
			total_panel_count += 1

	if total_panel_count > expected_panel_count:
		var to_remove : int = total_panel_count - expected_panel_count
		var removed_count : int = 0
		for i in range(mod_container.get_child_count() - 1, -1, -1):
			if removed_count >= to_remove: break
			if i != dissolving_index:
				var child = mod_container.get_child(i)
				child.free() 
				removed_count += 1

	var player_idx = 0
	for i in mod_container.get_child_count():
		if i == dissolving_index:
			continue
		if player_idx < player_mod_size:
			var panel : ModifierUIPanel = mod_container.get_child(i)
			panel.texture_rect.texture = GlobalResourceLoader.modifier_cache[player.mod_resource_ids[player_idx]].texture
			panel.reset_dissolve()
			player_idx += 1
	
	if player.current_modifier < 0:
		mod_name.text = "なし"
	else:
		if player.current_modifier < player.mod_resource_ids.size():
			mod_res_name = GlobalResourceLoader.modifier_cache[player.mod_resource_ids[player.current_modifier]].modifier_name
			mod_name.text = mod_res_name
		else:
			mod_name.text = "なし"
	
	carouse_container.player = player
	carouse_container.selected_index = player.current_modifier


func init_ui() -> void:
	for node in mod_container.get_children():
		node.queue_free()
	mod_name.text = "なし"

func _on_player_modifier_updated(player : Player) -> void:
	texture_update(player)
	
