extends Node2D
class_name MainGame

@export var enemy_damage_addition : float
@export var enemy_hp_addition : float

@onready var player_ui: GameUI = $PlayerUI
@onready var player: Player = $Player
@onready var room_generator: RoomGenerator = $RoomGenerator
@onready var camera_2d: Camera = $Camera2D
@onready var bgm_changer: BGMChanger = $BGMChanger

func _ready() -> void:
	room_generator.main_game_node = self
	room_generator.room_generate()
	player.global_position = room_generator.lobby_room.player_marker.global_position
	player_ui.player = self.player
	player_ui.player_hp_ui.player = self.player
	player.modifier_updated.connect(player_ui._on_character_modifier_updated)
	player.modifier_updated.connect(player_ui.mod_ui._on_player_modifier_updated)
	player.applied_modifier.connect(player_ui.modifier_timer._on_player_applied_modifier)
	player.hp_component.hp_changed.connect(player_ui.player_hp_ui._on_player_hp_changed)
	player.modifier_picked_up.connect(player_ui._on_modifier_picked_up)

func _process(delta: float) -> void:
	pass

func _on_risk_selected(id : String) -> void:
	if id == "EnemyAttackInc":
		enemy_damage_addition += 5
	if id == "EnemyHealthInc":
		enemy_hp_addition += 15
	if id == "EnemyAttackHealtgInc":
		enemy_damage_addition += 3
		enemy_hp_addition += 10
