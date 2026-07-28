extends Marker2D
class_name EnemySpawnPoint

@export var enemys : Array[PackedScene] = []
@export var is_random : bool
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal enemy_summoned(enemy : Enemy)

var main_game_node : MainGame
var enemy : Enemy
var target_container : Node2D

func _summon() -> void:
	if is_random:
		enemys.shuffle()
	if enemys.size() < 0:
		print(self.name + " : 敵が設定されていません。")
		return
	enemy = enemys[0].instantiate()
	if target_container:
		target_container.add_child(enemy)
	else:
		add_child(enemy)
	enemy.global_position = global_position
	enemy_summoned.emit(enemy)
	enemy.main_game_node = self.main_game_node
