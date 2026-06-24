extends Node2D
class_name RiskObelisk

const RISK_RETURN_UI = preload("uid://cisg26nogsxyt")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_player_inside : bool = false
var is_call : bool = false
var parent : MainGame

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_inside = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_inside = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Down") and !is_call and is_player_inside:
		is_call = true
		parent = get_tree().current_scene
		var ui : RiskReturnUI = RISK_RETURN_UI.instantiate()
		parent.player_ui.add_child(ui)
