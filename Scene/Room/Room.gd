extends Node2D
class_name Room

@export var player_marker : Marker2D

@onready var doors: Node2D = $Doors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_door(direction : Door.Direction) -> Door:
	for i in doors.get_children():
		var door : Door = i as Door
		if door.dir == direction:
			return door
	return null
