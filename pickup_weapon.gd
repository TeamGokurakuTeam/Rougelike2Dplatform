extends Node2D
class_name PickupWeapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var panel : Panel

var player : Player
var is_player_entered : bool
var trigered_event : bool

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Down") and is_player_entered and not trigered_event:
		trigered_event = true
		GameEvents.cutscene_started.emit()
		animation_player.play("Start")
		await animation_player.animation_finished
		#playerに初期武器を追加する処理
		#目の前のDoorを開ける処理

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		is_player_entered = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player and not trigered_event:
		player = null
		is_player_entered = false
