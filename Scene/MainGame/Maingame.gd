extends Node2D
class_name MainGame

const DOOR = preload("uid://cmin4ppf3tbti")
const PLAYER_SPAWN = preload("uid://di5wuga8fd5i4")

@onready var player_ui: GameUI = $PlayerUI
@onready var generator: EdgarRenderer2D = $Generator

var player : Player

func _ready() -> void:
	await generator.custom_post_process
	player = get_tree().get_first_node_in_group("Player")
	player_ui.player = player
	player_ui.player_hp_ui.player = player
	player.pickup_item.connect(player_ui._on_character_pickup_item)
	player.pickup_modifier.connect(player_ui.mod_ui._on_player_pickup_modifier)
	player.applied_modifier.connect(player_ui.modifier_timer._on_player_applied_modifier)
	player.hp_component.hp_changed.connect(player_ui.player_hp_ui._on_player_hp_changed)
	for node in generator.get_children():
		generator.clear(node)
	generator.generate_layout()
	generator.render()
	generator.marker_post_process.connect(_marker_post_process)

func _marker_post_process(tile_map_layer: TileMapLayer, marker: Node, data: Variant) -> void:
	var player_marker : PlayerSpawner = PLAYER_SPAWN.instantiate()
	get_tree().current_scene.add_child(player_marker)
	player_marker.global_position = marker.global_position

func _process(delta: float) -> void:
	pass
