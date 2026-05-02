extends State
class_name MageSpell

@export var animation_player: AnimationPlayer
@export var parent: Node2D        # Mage の本体（親ノード）
@export var flare_ball_scene: PackedScene   # EnemyFlareBall のシーンを Inspector で設定

func Enter() -> void:
	animation_player.play("Spell")

	# Spell 開始時に頭上へ生成
	_spawn_flare_ball()


func Exit() -> void:
	pass


func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "Idle")


func Physics_Update(delta) -> void:
	pass


func _spawn_flare_ball() -> void:
	if flare_ball_scene == null:
		print("flare_ball_scene が設定されていません")
		return

	# インスタンス生成
	var flare = flare_ball_scene.instantiate()

	# 親（Mage）の頭上に配置
	var spawn_pos = parent.global_position + Vector2(0, -40)
	flare.global_position = spawn_pos

	# シーンに追加
	get_tree().current_scene.add_child(flare)
