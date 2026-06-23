extends Marker2D
class_name EnemySpawnPoint

@export var enemys : Array[PackedScene]
@export var is_random : bool
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal enemy_summoned(enemy : Enemy)

var main_game_node : MainGame

func _summon() -> void:
	if is_random:
		enemys.shuffle()
	if enemys.size() < 0:
		print(self.name + " : 敵が設定されていません。")
		return
	var enemy : Enemy = enemys[0].instantiate()
	add_child(enemy)
	enemy_summoned.emit(enemy)
	enemy.main_game_node = self.main_game_node
