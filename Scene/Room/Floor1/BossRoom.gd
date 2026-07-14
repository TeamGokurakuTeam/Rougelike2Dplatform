extends Room
class_name BossRoom

const GOLEM_BOSS = preload("uid://bthj1ytrgopek")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boss_object: AnimatedSprite2D = $BossObject
@onready var collision_shape_2d: CollisionShape2D = $PlayerDetector/CollisionShape2D
@onready var boss_room_camera: Camera = $BossRoomCamera

func _ready() -> void:
	collision_shape_2d.disabled = false

func _on_player_detector_body_entered(body: Node2D) -> void:
	main_game_node.change_camera(boss_room_camera)
	GameEvents.cutscene_started.emit()
	animation_player.play("Start")
	main_game_node.player_ui.ui_fade_in()
	await animation_player.animation_finished
	main_game_node.player_ui.ui_fade_out()
	boss_summon()
	GameEvents.cutscene_ended.emit()
	main_game_node.change_camera(main_game_node.main_camera)

func boss_summon() -> void:
	var boss : GolemBoss = GOLEM_BOSS.instantiate()
	add_child(boss)
	boss.main_game_node = main_game_node
	boss.global_position = boss_object.global_position
	boss.hp_component.is_dead.connect(_on_boss_is_dead)
	boss_object.visible = false
	enemy_count += 1
	battle_bgm_type = BGMChanger.BGMType.BATTLE
	main_game_node.bgm_changer.change_bgm(battle_bgm_type)

func _on_boss_is_dead() -> void:
	enemy_count -= 1
	if enemy_count <= 0:
		for node in doors.get_children():
			var door : Door = node as Door
			door.animation_player.play("Open")
		main_game_node.bgm_changer.change_bgm(BGMChanger.BGMType.STAGE)
