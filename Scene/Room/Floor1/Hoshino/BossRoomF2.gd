extends Room
class_name BossRoomF2

#まだ変更してない
const GOLEM_BOSS = preload("uid://bthj1ytrgopek")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boss_object: AnimatedSprite2D = $BossObject
@onready var collision_shape_2d: CollisionShape2D = $PlayerDetector/CollisionShape2D
@onready var boss_room_camera: Camera = $BossRoomCamera
@onready var animation_player1: AnimationPlayer = $TileMaps/Decoration2/AnimationPlayer



func _ready() -> void:
	super._ready()
	auto_spawn_enemies = false
	collision_shape_2d.disabled = false
	boss_object.visible = true
	#デバック
	animation_player.play("Start")
	animation_player1.play("Bubble")

func _on_player_detector_body_entered(body: Node2D) -> void:
	main_game_node.change_camera(boss_room_camera)
	GameEvents.cutscene_started.emit()
	#battle_bgm_type = BGMChanger.BGMType.BOSS
	#main_game_node.bgm_changer.change_bgm(battle_bgm_type)
	await main_game_node.transition_offset_tween.finished
	animation_player.play("Start")
	main_game_node.player_ui.ui_fade_in()
	await animation_player.animation_finished
	main_game_node.player_ui.ui_fade_out()
	boss_summon()
	GameEvents.cutscene_ended.emit()
	main_game_node.change_camera(main_game_node.main_camera)

func boss_summon() -> void:
	var boss : GolemBoss = GOLEM_BOSS.instantiate()
	enemies.add_child(boss)
	boss.main_game_node = main_game_node
	boss.global_position = boss_object.global_position
	boss.hp_component.is_dead.connect(_on_boss_is_dead)
	boss_object.visible = false
	enemy_count += 1
	GameEvents.battle_start.emit()

func _on_boss_is_dead() -> void:
	_on_enemy_is_dead()
