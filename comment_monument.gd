extends Node2D
class_name CommentMonument

@export var visible_second : float = 5.0
@export_multiline() var text : String

@onready var press: Label = $Press
@onready var label: Label = $Panel/Label
@onready var panel: Panel = $Panel

var is_entered : bool = false
var is_opening : bool = false
var tween : Tween

func _ready() -> void:
	tween = create_tween()
	_panel_init()

func _process(delta: float) -> void:
	if is_entered:
		if is_opening and Input.is_action_just_pressed("UI_Down"):
			tween.kill()
			label.visible_ratio = 1.0
		elif Input.is_action_just_pressed("UI_Down"):
			if tween != null:
				_panel_open()

func _on_area_2d_body_entered(body: Node2D) -> void:
	press.visible = true
	is_entered = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_entered = false
	is_opening = false
	_panel_init()

func _panel_open() -> void:
	is_opening = true
	press.visible = false
	panel.visible = true
	label.text = text
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, visible_second)
	await tween.finished
	await get_tree().create_timer(5.0).timeout
	_panel_init()
	panel.visible = false
	press.visible = true
	is_opening = false

func _panel_init() -> void:
	label.text = ""
	label.visible_ratio = 0.0
	panel.visible = false
	press.visible = false
	tween.kill()
