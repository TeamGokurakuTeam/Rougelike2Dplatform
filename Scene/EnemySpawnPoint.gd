extends Marker2D
class_name EnemySpawnPoint

@export var enemys : Array[PackedScene]
@export var is_random : bool
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

func _ready_to_spawn() -> void: ## anim_playerのSpawn終了後に実行
	if is_random:
		enemys.shuffle()
		_summon() 
	else:
		_summon() 

func _summon() -> void:
	if enemys.size() < 0:
		animation_player.play("Spawn")
		print(self.name + " : 敵が設定されていません。")
		return
	var enemy : Enemy = enemys[0].instantiate()
	add_child(enemy)
