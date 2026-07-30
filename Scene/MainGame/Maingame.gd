extends Node2D
class_name MainGame

@export_category("敵バフ")
@export var enemy_damage_addition : float
@export var enemy_hp_addition : float

@export_category("デバッグ専用")
@export var debug_input_buffer : String = ""

@onready var player_ui: GameUI = $PlayerUI
@onready var player: Player = $Player
@onready var room_generator: RoomGenerator = $RoomGenerator
@onready var main_camera: Camera = $MainCamera
@onready var bgm_changer: BGMChanger = $BGMChanger

var transition_tween : Tween
var transition_zoom_tween : Tween
var transition_offset_tween : Tween
var current_camera : Camera2D

var current_room : Room

func _ready() -> void:
	set_process_input(true)
	current_camera = main_camera
	main_camera.make_current()
	room_generator.main_game_node = self
	player.main_game_node = self

	room_generator.room_generate()
	current_room = room_generator.lobby_room

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

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var key_event : InputEventKey = event

		# 押したキーを記録、最後がdebugだったらデバッグモードをON
		if not Common.debug_mode:
			_record_pressed_key(key_event)

		if not Common.debug_mode:
			return

		match key_event.keycode:
			KEY_K:
				Common.debug_print("敵全員殺すぜ")
				kill_current_room_enemies()
			KEY_T:
				Common.debug_print("一番遠いドアにテレポート")
				teleport_player_to_furthest_door()


func _record_pressed_key(key_event : InputEventKey) -> void:
	if key_event == null:
		return
	if key_event.keycode < KEY_A or key_event.keycode > KEY_Z:
		return
	var key_char : String = char(key_event.unicode).to_lower()
	if key_char == "":
		return
	debug_input_buffer += key_char
	if debug_input_buffer.ends_with("debug"):
		Common.debug_mode = true
		Common.debug_print("デバッグモード開始")
		debug_input_buffer = ""

	if debug_input_buffer.length() > 10:
		debug_input_buffer = debug_input_buffer.right(5)

func kill_current_room_enemies() -> void:
	if current_room == null:
		return
	for child in current_room.enemies.get_children():
		if child is Enemy:
			child.hp_component.hp = 0

func teleport_player_to_furthest_door() -> void:
	if player == null:
		return
	if current_room == null:
		return

	var furthest_door_index : int = -1
	var furthest_distance : float = 0
	for i in current_room.doors.get_child_count():
		if current_room.doors.get_child(i) is not Door:
			continue
		var door : Door = current_room.doors.get_child(i) as Door
		var distance : float = door.global_position.distance_to(player.global_position)
		if distance > furthest_distance:
			furthest_door_index = i
			furthest_distance = distance

	if furthest_door_index >= 0:
		var furthest_door : Door = current_room.doors.get_child(furthest_door_index) as Door
		player.global_position = furthest_door.exit_point.global_position