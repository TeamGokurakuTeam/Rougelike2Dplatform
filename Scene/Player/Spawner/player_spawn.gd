extends Node2D
class_name PlayerSpawner

@export var player_scene : PackedScene
@export var camera_scene : PackedScene

func _ready() -> void:
	summon()

func summon() -> void:
	var player : Player = player_scene.instantiate()
	get_tree().current_scene.add_child(player)
	player.global_position = self.global_position
	var camera : Camera = camera_scene.instantiate()
	get_tree().current_scene.add_child(camera)
	player.camera_node_path = camera.get_path()
