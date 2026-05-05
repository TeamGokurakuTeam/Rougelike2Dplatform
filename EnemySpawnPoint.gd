extends Marker2D
class_name EnemySpawnPoint

@export var enemys : Array[Character]

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("Spawn")
