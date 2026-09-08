extends Enemy
class_name Infector

@onready var marker: Marker2D = $Marker2D

const HEDORO_GEAR = preload("uid://02rhrcwex5jr")

func shoot() -> void:
	var gear : HedoroGear = HEDORO_GEAR.instantiate()
	get_tree().current_scene.add_child(gear)
	gear.global_position = marker.global_position
