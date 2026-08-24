extends Node2D
class_name RiskObelisk

const RISK_RETURN_UI = preload("uid://cisg26nogsxyt")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $PlayerDetector/CollisionShape2D
@onready var label: Label = $Label

@export var is_obelisk_locked : bool = true

var is_player_inside : bool = false
var is_call : bool = false
var parent : MainGame

func _ready() -> void:
	label.visible = false

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player and not is_obelisk_locked:
		is_player_inside = true
		label.visible = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player and not is_obelisk_locked:
		is_player_inside = false
		label.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Down") and !is_call and is_player_inside:
		GameEvents.cutscene_started.emit()
		collision_shape_2d.disabled = true
		is_call = true
		parent = get_tree().current_scene
		var ui : RiskReturnUI = RISK_RETURN_UI.instantiate()
		ui.obelisk = self
		ui.parent = parent
		parent.player_ui.add_child(ui)
		ui.risk_selected.connect(parent._on_risk_selected)
