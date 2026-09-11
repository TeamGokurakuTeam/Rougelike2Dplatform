extends Area2D
class_name RoomEnterDetector

@export var doors : Array[Door]

@onready var encounter_component : EncounterComponent = $EncounterComponent
@onready var enemy_spawn_points: Node2D = $EnemySpawnPoints

var room : Room

func _ready() -> void:
	encounter_component.doors.assign(doors)
	encounter_component.spawn_points.assign(enemy_spawn_points.get_children())
	encounter_component.target_container = self
	encounter_component.encounter_cleared.connect(_on_encounter_cleared)
	body_entered.connect(_on_body_entered)

func setup(host_room : Room) -> void:
	room = host_room
	encounter_component.room = room
	encounter_component.main_game_node = room.main_game_node

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		encounter_component.trigger()

func _on_encounter_cleared() -> void:
	GameEvents.battle_end.emit()
