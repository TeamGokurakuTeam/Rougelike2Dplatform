extends Node2D
class_name Room

@export var auto_spawn_enemies : bool = true
@export var can_spawn_enemy : bool = true
@export var player_marker : Marker2D
@export var battle_bgm_type : BGMChanger.BGMType = BGMChanger.BGMType.BATTLE
@export var obelisk : RiskObelisk

@onready var doors: Node2D = $Doors
@onready var enemy_spawn_points: Node2D = $EnemySpawnPoints
@onready var hide_wall: HideTileMap = $TileMaps/HideWall
@onready var enemies: Node2D = $Enemies
@onready var traps: Node2D = $Traps
@onready var encounter_component : EncounterComponent = $EncounterComponent

var main_game_node : MainGame
var room_type : RoomInfoResource.RoomType
var depth : int = -1

func _ready() -> void:
	_initialize_room()

func _initialize_room() -> void:
	for node in doors.get_children():
		var door : Door = node as Door
		door.main_game_node = main_game_node
		door.current_room = self
		door.exit_door_player_entered.connect(_on_exit_door_player_entered)

	for node in get_children():
		if node is Character:
			node.room = self
		elif node is RoomEnterDetector:
			node.setup(self)

	if enemies:
		for node in enemies.get_children():
			if node is Character:
				node.main_game_node = main_game_node
				node.room = self

	if main_game_node and main_game_node.player:
		hide_wall.player = main_game_node.player

	encounter_component.doors.assign(doors.get_children())
	encounter_component.spawn_points.assign(enemy_spawn_points.get_children())
	encounter_component.target_container = enemies
	encounter_component.main_game_node = main_game_node
	encounter_component.room = self
	encounter_component.encounter_cleared.connect(_on_encounter_cleared)

	if obelisk != null and encounter_component.enemy_count <= 0:
		obelisk.is_obelisk_locked = false

func get_door(direction : Door.Direction) -> Door:
	for i in doors.get_children():
		var door : Door = i as Door
		door.main_game_node = main_game_node
		if door.dir == direction:
			return door
	return null

func _on_exit_door_player_entered(player : Player) -> void:
	main_game_node.current_room = self
	if auto_spawn_enemies:
		spawn_enemies()

func spawn_enemies() -> void:
	if not can_spawn_enemy:
		return
	can_spawn_enemy = false
	encounter_component.trigger()
	main_game_node.bgm_changer.change_bgm(battle_bgm_type)

func _turn_off_all_traps() -> void:
	if traps == null:
		return
	for node in traps.get_children():
		if node is not ComponentHost:
			continue
		var host : ComponentHost = node as ComponentHost
		if not host.has_component("TrapComponent"):
			continue
		host.get_component("TrapComponent").is_active = false

func _on_encounter_cleared() -> void:
	main_game_node.bgm_changer.change_bgm(BGMChanger.BGMType.STAGE)
	GameEvents.battle_end.emit()
	if obelisk != null:
		obelisk.is_obelisk_locked = false
	_turn_off_all_traps()

func open_all_doors() -> void:
	encounter_component.open_doors()
