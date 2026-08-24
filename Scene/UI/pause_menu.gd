extends Control
class_name PauseMenuUI

const TITLE = preload("uid://d15a301cfnn87")

var title_scene : PackedScene

func _on_continue_pressed() -> void:
	queue_free()
	get_tree().paused = false

func _on_title_pressed() -> void:
	queue_free()
	title_scene = TITLE
	get_tree().paused = false
	get_tree().change_scene_to_packed(title_scene)
