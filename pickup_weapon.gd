extends Node2D
class_name PickupWeapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var panel : Panel
@export var door : Door

var player : Player
var is_player_entered : bool
var is_event_triggered : bool

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Down") and is_player_entered and not is_event_triggered:
		is_event_triggered = true
		GameEvents.cutscene_started.emit()
		animation_player.play("Start")
		await animation_player.animation_finished
		GameEvents.cutscene_ended.emit()
		door.is_open = true
		panel.visible = false
		#playerに初期武器を追加する処理
		player.set_player_default_weapon("A_NewWorld")
		#目の前のDoorを開ける処理
		door.open()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		is_player_entered = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player and not is_event_triggered:
		player = null
		is_player_entered = false
