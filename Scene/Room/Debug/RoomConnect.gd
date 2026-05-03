extends Node2D
class_name RoomConnect

@export var first_room : PackedScene
@export var second_room : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_room()

func _generate_room() -> void:
	if first_room == null:
		return
	var first_room_node : Room = first_room.instantiate()
	add_child(first_room_node)
	if first_room_node.ExitPoint == null:
		return
	if second_room == null:
		return
	var second_room_node : Room = second_room.instantiate()
	var prev_connect_point : Vector2 = first_room_node.ExitPoint.global_position
	#prev_connect_point = first_room_node.to_local(prev_connect_point)
	add_child(second_room_node)
	var next_connect_point : Vector2 = Vector2(prev_connect_point.x, prev_connect_point.y - 16) 
	print(next_connect_point)
	var init_point : Vector2 = next_connect_point - second_room_node.StartPoint.global_position
	print(init_point)
	second_room_node.global_position = init_point
	
	
	
