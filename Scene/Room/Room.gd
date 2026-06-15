extends Node2D
class_name Room

@export var can_spawn_enemy : bool = true
@export var player_marker : Marker2D

@onready var doors: Node2D = $Doors
@onready var enemy_spawn_points: Node2D = $EnemySpawnPoints

var enemy_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in doors.get_children():
		var door : Door = node as Door
		door.exit_door_player_entered.connect(_on_exit_door_player_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_door(direction : Door.Direction) -> Door:
	for i in doors.get_children():
		var door : Door = i as Door
		if door.dir == direction:
			return door
	return null

func _on_exit_door_player_entered(player : Player) -> void:
	if not can_spawn_enemy:
		return
	can_spawn_enemy = false
	for point in enemy_spawn_points.get_children():
		var enemy_point : EnemySpawnPoint = point as EnemySpawnPoint
		enemy_point.animation_player.play("Spawn")
		enemy_point.enemy_summoned.connect(_on_enemy_summoned)
	for node in doors.get_children():
		var door : Door = node as Door
		door.player_detector.monitoring = false

func _on_enemy_summoned(enemy : Enemy) -> void:
	enemy.hp_component.is_dead.connect(_on_enemy_is_dead)
	enemy_count += 1

func _on_enemy_is_dead() -> void:
	enemy_count -= 1
	if enemy_count <= 0:
		for node in doors.get_children():
			var door : Door = node as Door
			door.player_detector.monitoring = true
