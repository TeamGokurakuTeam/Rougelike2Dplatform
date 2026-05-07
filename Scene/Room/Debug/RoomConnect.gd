extends Node2D
class_name RoomConnect

@export_category("各部屋のディレクトリ")
@export_dir var lobby_room_dir ## 必ず最初に生成する部屋
@export_dir var enemy_room_dir ## 道中に生成される部屋
@export_dir var bonus_room_dir ## 一定確率で生成される部屋
@export_dir var shop_room_dir ## どこかで必ず生成されるショップ
@export_dir var boss_room_dir ## 最上階に必ず生成するショップ
@export_dir var end_room_dir ## ボスを倒した後に到達できる部屋(次のステージへ)

@export_category("生成する部屋の数")
@export var generate_room_value : int = 6

var current_generate_room_value : int

#var lobby_room_scenes : Array[PackedScene]
#var enemy_room_scenes : Array[PackedScene]
#var bonus_room_scenes : Array[PackedScene]
#var shop_room_scenes : Array[PackedScene]
#var boss_room_scenes : Array[PackedScene]

enum RoomType {
	Lobby,
	Enemy,
	Bonus,
	Shop,
	Boss,
	End
}

var room_dictionary : Dictionary[RoomType, Array]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if lobby_room_dir:
		_load_room(lobby_room_dir, RoomType.Lobby)
	if enemy_room_dir:
		_load_room(enemy_room_dir, RoomType.Enemy)
	if bonus_room_dir:
		_load_room(bonus_room_dir, RoomType.Bonus)
	if shop_room_dir:
		_load_room(shop_room_dir, RoomType.Shop)
	if boss_room_dir:
		_load_room(boss_room_dir, RoomType.Boss)
	if end_room_dir:
		_load_room(end_room_dir, RoomType.End)
	
	_generate_room()

func _load_room(directory : String, type : RoomType) -> void:
	room_dictionary[type] = []
	var folder : DirAccess = DirAccess.open(directory)
	folder.list_dir_begin()
	var file_name : String = folder.get_next()
	while file_name != "":
		var scene : PackedScene = load(directory + "/" + file_name)
		room_dictionary[type].append(scene)
		file_name = folder.get_next()

func _generate_room() -> void:
	if room_dictionary[RoomType.Lobby] == null:
		return
	var lobby_room_path : PackedScene = room_dictionary[RoomType.Lobby].pick_random()
	var lobby_room_node : Room = lobby_room_path.instantiate()
	add_child(lobby_room_node)
	if lobby_room_node.ExitPoint == null:
		return
	if room_dictionary[RoomType.Enemy] == null:
		return
	room_dictionary[RoomType.Enemy].shuffle()
	var prev_room : Room
	var prev_connect_point : Vector2
	for i in generate_room_value:
		var enemy_room_path : PackedScene = room_dictionary[RoomType.Enemy][i]
		var enemy_room_node : Room = enemy_room_path.instantiate()
		if i == 0:
			prev_connect_point = lobby_room_node.ExitPoint.global_position
			prev_room = enemy_room_node
			add_child(enemy_room_node)
		else:
			prev_connect_point = prev_room.ExitPoint.global_position
			add_child(enemy_room_node)
			prev_room = enemy_room_node
		var next_connect_point : Vector2 = Vector2(prev_connect_point.x, prev_connect_point.y - 16)
		var init_point : Vector2 = next_connect_point - enemy_room_node.StartPoint.global_position
		enemy_room_node.global_position = init_point
	#ここに全生成した後BossRoomを生成
	if room_dictionary[RoomType.Boss] == null:
		return
	prev_connect_point = prev_room.ExitPoint.global_position
	var boss_room_scene : PackedScene = room_dictionary[RoomType.Boss].pick_random()
	var boss_room : Room = boss_room_scene.instantiate()
	add_child(boss_room)
	var next_connect_point : Vector2 = Vector2(prev_connect_point.x, prev_connect_point.y - 16)
	var init_point : Vector2 = next_connect_point - boss_room.StartPoint.global_position
	boss_room.global_position = init_point
	prev_room = boss_room
	#BossRoomを生成した後、EndRoomを生成する
	if end_room_dir == null:
		return
	if room_dictionary[RoomType.End] == null:
		return
	prev_connect_point = prev_room.ExitPoint.global_position
	var end_room_scene : PackedScene = room_dictionary[RoomType.End].pick_random()
	var end_room : Room = end_room_scene.instantiate()
	add_child(end_room)
	next_connect_point = Vector2(prev_connect_point.x, prev_connect_point.y - 16)
	init_point = next_connect_point - end_room.StartPoint.global_position
	end_room.global_position = init_point
	prev_room = end_room
	
	#var second_room_node : Room = second_room.instantiate()
	#var prev_connect_point : Vector2 = first_room_node.ExitPoint.global_position
	##prev_connect_point = first_room_node.to_local(prev_connect_point)
	#add_child(second_room_node)
	 #
	
	
	
	
