extends Node2D
class_name MainGame



@onready var player_ui: GameUI = $PlayerUI
@onready var generator: DungeonGeneratorFloor1 = $Generator

var player : Player

const DOOR = preload("uid://cmin4ppf3tbti")
const PLAYER_SPAWN = preload("uid://di5wuga8fd5i4")
const CAMERA_2D = preload("uid://cvnfa7dppgwhv")

var player_marker : PlayerSpawner 

func _ready() -> void:
	for node in generator.get_children():
		generator.clear(node)
	generator.generate_layout()
	generator.render()
	
	player_marker = PLAYER_SPAWN.instantiate()
	get_tree().current_scene.add_child(player_marker)
	player_marker.position = generator.player_spawn_coordinate
	player_marker.summon()
	
	var camera : Camera = CAMERA_2D.instantiate()
	add_child(camera)
	player = get_tree().get_first_node_in_group("Player")
	player.camera_node_path = camera.get_path()
	camera.global_position = player.global_position
	player_ui.player = player
	player_ui.player_hp_ui.player = player
	player.pickup_item.connect(player_ui._on_character_pickup_item)
	player.pickup_modifier.connect(player_ui.mod_ui._on_player_pickup_modifier)
	player.applied_modifier.connect(player_ui.modifier_timer._on_player_applied_modifier)
	player.hp_component.hp_changed.connect(player_ui.player_hp_ui._on_player_hp_changed)

func _process(delta: float) -> void:
	pass
