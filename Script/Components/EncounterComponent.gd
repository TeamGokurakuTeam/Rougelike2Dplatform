extends Component
class_name EncounterComponent

signal encounter_started()
signal encounter_cleared()

@export var doors : Array[Door]
@export var spawn_points: Array[EnemySpawnPoint]
@export var target_container : Node2D

var main_game_node : MainGame
var room : Room
var enemy_count : int = 0
var is_triggered : bool = false

func trigger() -> void:
	if is_triggered:
		return
	is_triggered = true

	for point in spawn_points:
		if point is not EnemySpawnPoint:
			continue
		point.main_game_node = main_game_node
		point.target_container = target_container
		point.animation_player.play("Spawn")
		point.enemy_summoned.connect(_on_enemy_summoned)

	for door in doors:
		door.lock()

	encounter_started.emit()

func open_doors() -> void:
	for door in doors:
		door.open()

func register_enemy(enemy : Enemy) -> void:
	_on_enemy_summoned(enemy)

func _on_enemy_summoned(enemy : Enemy) -> void:
	if room:
		enemy.room = room
	enemy.hp_component.is_dead.connect(_on_enemy_is_dead)
	enemy_count += 1
	GameEvents.battle_start.emit()

func _on_enemy_is_dead() -> void:
	enemy_count -= 1
	if enemy_count <= 0:
		open_doors()
		encounter_cleared.emit()