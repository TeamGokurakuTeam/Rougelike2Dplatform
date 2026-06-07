extends Node2D
class_name Room

@export var player_marker : Marker2D

@onready var doors: Node2D = $Doors


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func get_door(direction : Door.Direction) -> Door:
	for i in doors.get_children():
		var door : Door = i as Door
		if door.dir == direction:
			return door
	return null
