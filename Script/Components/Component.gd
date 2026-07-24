extends Node2D
class_name Component

@export var component_id : String

var owner_host: ComponentHost

func setup(host: ComponentHost) -> void:
	owner_host = host