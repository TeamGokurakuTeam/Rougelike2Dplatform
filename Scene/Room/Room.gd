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

var enemy_count : int = 0
var main_game_node : MainGame

func _ready() -> void:
	_initialize_room()

func _initialize_room() -> void:
	for node in doors.get_children():
		var door : Door = node as Door
		door.exit_door_player_entered.connect(_on_exit_door_player_entered)

	for node in get_children():
		if node is Character:
			node.room = self
	
	if enemies:
		for node in enemies.get_children():
			if node is Character:
				node.room = self

	if main_game_node and main_game_node.player:
		hide_wall.player = main_game_node.player

	if obelisk != null and enemy_count <= 0:
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
	for point in enemy_spawn_points.get_children():
		var enemy_point : EnemySpawnPoint = point as EnemySpawnPoint
		enemy_point.main_game_node = self.main_game_node
		enemy_point.target_container = enemies
		enemy_point.animation_player.play("Spawn")
		enemy_point.enemy_summoned.connect(_on_enemy_summoned)
	for node in doors.get_children():
		var door : Door = node as Door
		door.lock()
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

func _on_enemy_summoned(enemy : Enemy) -> void:
	enemy.room = self
	enemy.hp_component.is_dead.connect(_on_enemy_is_dead)
	enemy_count += 1
	GameEvents.battle_start.emit()

func _on_enemy_is_dead() -> void:
	enemy_count -= 1
	if enemy_count <= 0:
		open_all_doors()
		main_game_node.bgm_changer.change_bgm(BGMChanger.BGMType.STAGE)
		GameEvents.battle_end.emit()
		if obelisk != null:
			obelisk.is_obelisk_locked = false
		_turn_off_all_traps()

func open_all_doors() -> void:
	for node in doors.get_children():
		var door : Door = node as Door
		door.open()
