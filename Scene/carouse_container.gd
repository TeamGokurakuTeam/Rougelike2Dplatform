@tool
extends Control
class_name CarouseContainer

@export var spacing : float = 20.0

@export var wraparound_enabled : bool = false
@export var wraparound_radius : float = 300.0
@export var wraparound_height : float = 50.0

@export_range(0.0, 1.0) var opacity_strength : float = 0.35
@export_range(0.0, 1.0) var scale_strength : float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min : float = 0.1

@export var smoothing_speed : float = 6.5
@export var selected_index : int = 0
@export var follow_button_focus : bool = false

var lock_scroll : bool = false

@export var position_offset_node : Control = null

var player : Player

func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() <= 0:
		return
	
	if not lock_scroll:
		selected_index = clamp(selected_index, 0, position_offset_node.get_child_count() - 1)
	
	for i in position_offset_node.get_child_count():
		var node = position_offset_node.get_child(i)
		var control_node : Control = (node as Control)
		
		if wraparound_enabled:
			var max_index_range = max(1, (position_offset_node.get_child_count() - 1) / 2.0)
			var angle = clamp((i - selected_index) / max_index_range, -1.0, 1.0) * PI
			var x = sin(angle) * wraparound_radius
			var y = cos(angle) * wraparound_height
			var target_pos = Vector2(x, y - wraparound_height) - control_node.size / 2.0
			control_node.position = lerp(control_node.position, target_pos, smoothing_speed * delta)
		else:
			var position_x = 0
			if i > 0:
				position_x = position_offset_node.get_child(i - 1).position.x + position_offset_node.get_child(i - 1).size.x + spacing
			control_node.position = Vector2(position_x, -control_node.size.y / 2.0)
	
		control_node.pivot_offset = control_node.size / 2.0
		var target_scale = 1.0 - (scale_strength * abs(i - selected_index))
		target_scale = clamp(target_scale, scale_min, 1.0)
		control_node.scale = lerp(control_node.scale, Vector2.ONE * target_scale, smoothing_speed * delta)
	
		var target_opacity = 1.0 - (opacity_strength * abs(i - selected_index))
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		control_node.modulate.a = lerp(control_node.modulate.a, target_opacity, smoothing_speed * delta)
		
		
		if i == selected_index:
			control_node.z_index = 1
			if control_node is WeaponSelectPanel:
				control_node.button.mouse_filter = Control.MOUSE_FILTER_PASS
			if control_node is ModifierUIPanel:
				control_node.sparkling = player != null and player.weapon != null and player.weapon.has_modifiers("Substitute")
		else:
			control_node.z_index = -abs(i - selected_index)
			if control_node is WeaponSelectPanel:
				control_node.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if control_node is ModifierUIPanel:
				control_node.sparkling = false
	
		if follow_button_focus and control_node.has_focus():
			selected_index = i
	
	if wraparound_enabled:
		position_offset_node.position.x = lerp(position_offset_node.position.x, 0.0, smoothing_speed * delta)
	else:
		position_offset_node.position.x = lerp(position_offset_node.position.x, -(position_offset_node.get_child(selected_index).position.x + position_offset_node.get_child(selected_index).size.x / 2.0), smoothing_speed * delta)

func left() -> void:
	if lock_scroll:
		return
	selected_index -= 1
	if selected_index < 0:
		selected_index += 1

func right() -> void:
	if lock_scroll:
		return
	selected_index += 1
	if selected_index > position_offset_node.get_child_count() - 1:
		selected_index -= 1
