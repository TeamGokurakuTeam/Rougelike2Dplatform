extends Node2D
class_name MainGame

@export var enemy_damage_addition : float
@export var enemy_hp_addition : float

@onready var player_ui: GameUI = $PlayerUI
@onready var player: Player = $Player
@onready var room_generator: RoomGenerator = $RoomGenerator
@onready var main_camera: Camera = $MainCamera
@onready var bgm_changer: BGMChanger = $BGMChanger

var transition_tween : Tween
var transition_zoom_tween : Tween
var transition_offset_tween : Tween
var current_camera : Camera2D

func _ready() -> void:
	current_camera = main_camera
	main_camera.make_current()
	transition_tween = create_tween()
	transition_offset_tween = create_tween()
	transition_zoom_tween = create_tween()
	room_generator.main_game_node = self
	player.main_game_node = self
	room_generator.room_generate()
	player.global_position = room_generator.lobby_room.player_marker.global_position
	player_ui.player = self.player
	player_ui.player_hp_ui.player = self.player
	player.modifier_updated.connect(player_ui._on_character_modifier_updated)
	player.modifier_updated.connect(player_ui.mod_ui._on_player_modifier_updated)
	player.applied_modifier.connect(player_ui.modifier_timer._on_player_applied_modifier)
	player.hp_component.hp_changed.connect(player_ui.player_hp_ui._on_player_hp_changed)
	player.modifier_picked_up.connect(player_ui._on_modifier_picked_up)

func change_camera(target_camera: Camera2D) -> void:
	var final_transform := target_camera.global_transform
	var final_zoom := target_camera.zoom
	var final_offset := target_camera.offset

	target_camera.make_current()

	if transition_tween: transition_tween.kill()
	transition_tween = create_tween()
	transition_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	transition_tween.tween_property(target_camera, "global_transform", final_transform, 0.8)

	if transition_zoom_tween: transition_zoom_tween.kill()
	transition_zoom_tween = create_tween()
	transition_zoom_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	transition_zoom_tween.tween_property(target_camera, "zoom", final_zoom, 0.8)

	if transition_offset_tween: transition_offset_tween.kill()
	transition_offset_tween = create_tween()
	transition_offset_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	transition_offset_tween.tween_property(target_camera, "offset", final_offset, 0.8)

	current_camera = target_camera

func _on_risk_selected(id : String) -> void:
	if id == "EnemyAttackInc":
		enemy_damage_addition += 5
	if id == "EnemyHealthInc":
		enemy_hp_addition += 15
	if id == "EnemyAttackHealtgInc":
		enemy_damage_addition += 3
		enemy_hp_addition += 10
