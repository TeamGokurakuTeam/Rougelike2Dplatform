extends Node2D
class_name RoomGenerator

const ROOM_DISTANCE : int = 5000

@export_category("生成する部屋の数")
@export var generate_room_value : int = 6

var lobby_room : Room
var main_game_node : MainGame

#var current_generate_room_value : int

#var lobby_room_scenes : Array[PackedScene]
#var enemy_room_scenes : Array[PackedScene]
#var bonus_room_scenes : Array[PackedScene]
#var shop_room_scenes : Array[PackedScene]
#var boss_room_scenes : Array[PackedScene]

func room_generate() -> void:
	var lobby_index : int = 0
	var exit_index : int = generate_room_value - 1
	var boss_index : int = exit_index - 1
	
	var room_grid : Array[Array] = []
	var room_data : Array[Array] = []
	
	#二重配列を3行として扱い、forループでルームの初期化を行う
	for i in 3:
		room_grid.append([])
		room_data.append([])
		for j in generate_room_value:
			room_grid[i].append(0)
			room_data[i].append(null)
	
	#最初の部屋ではなかったら左の道を、最後の部屋ではなかったら右の道を作る
	for i in generate_room_value:
		if i != generate_room_value - 1:
			room_grid[1][i] |= Common.RIGHT_MASK
		if i != 0:
			room_grid[1][i] |= Common.LEFT_MASK
	
	for i in 3:
		for j in generate_room_value:
			var room_opening : int = room_grid[i][j]
			if room_opening == 0:
				continue
			var room_type : RoomInfoResource.RoomType = RoomInfoResource.RoomType.EMPTY
			
			#j(横)によって部屋のタイプを決める処理
			match j:
				lobby_index:
					room_type = RoomInfoResource.RoomType.LOBBY_ROOM
				exit_index:
					room_type = RoomInfoResource.RoomType.END_ROOM
				boss_index:
					room_type = RoomInfoResource.RoomType.BOSS_ROOM
				_: #これがmatchにおけるdefault
					room_type = RoomInfoResource.RoomType.ENEMY_ROOM
			var room_compare : Callable = func (res : RoomInfoResource):
				return res.room_type == room_type
			var room_res : RoomInfoResource = GlobalResourceLoader.room_cache[room_opening].filter(room_compare).pick_random()
			print(room_res)
			var room_node : Room = room_res.room_scene.instantiate()
			room_data[i][j] = room_node
			room_node.main_game_node = self.main_game_node
			add_child(room_node)
			room_node.global_position = Vector2(j * ROOM_DISTANCE, i * ROOM_DISTANCE)
		
	for i in 3:
		for j in generate_room_value: #今回のケースはiが縦、jが横
			var room : Room = room_data[i][j]
			if room == null:
				continue
			for k in room.doors.get_children():
				var door : Door = k as Door
				var other_room : Room
				var other_door : Door
				match door.dir:
					Door.Direction.UP:
						other_room = room_data[i - 1][j]
					Door.Direction.DOWN:
						other_room = room_data[i + 1][j]
					Door.Direction.LEFT:
						other_room = room_data[i][j - 1]
					Door.Direction.RIGHT:
						other_room = room_data[i][j + 1]
				if other_room == null:
					continue
				other_door = other_room.get_door(Door.get_opposite_dirction(door.dir))
				Door.connect_door(door, other_door)
		
		if room_data[1][0]:
			lobby_room = room_data[1][0] as Room
			

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if lobby_room_dir:
		#_load_room(lobby_room_dir, RoomType.Lobby)
	#if enemy_room_dir:
		#_load_room(enemy_room_dir, RoomType.Enemy)
	#if bonus_room_dir:
		#_load_room(bonus_room_dir, RoomType.Bonus)
	#if shop_room_dir:
		#_load_room(shop_room_dir, RoomType.Shop)
	#if boss_room_dir:
		#_load_room(boss_room_dir, RoomType.Boss)
	#if end_room_dir:
		#_load_room(end_room_dir, RoomType.End)
	#
	#_generate_room()
#
#func _load_room(directory : String, type : RoomType) -> void:
	#room_dictionary[type] = []
	#var folder : DirAccess = DirAccess.open(directory)
	#folder.list_dir_begin()
	#var file_name : String = folder.get_next()
	#while file_name != "":
		#var scene : PackedScene = load(directory + "/" + file_name)
		#room_dictionary[type].append(scene)
		#file_name = folder.get_next()
#
#func _generate_room() -> void:
	#if room_dictionary[RoomType.Lobby] == null:
		#return
	#var lobby_room_path : PackedScene = room_dictionary[RoomType.Lobby].pick_random()
	#var lobby_room_node : Room = lobby_room_path.instantiate()
	#add_child(lobby_room_node)
	#if lobby_room_node.ExitPoint == null:
		#return
	#if room_dictionary[RoomType.Enemy] == null:
		#return
	#room_dictionary[RoomType.Enemy].shuffle()
	#var prev_room : Room
	#var prev_connect_point : Vector2
	#for i in generate_room_value:
		#var enemy_room_path : PackedScene = room_dictionary[RoomType.Enemy][i]
		#var enemy_room_node : Room = enemy_room_path.instantiate()
		#if i == 0:
			#prev_connect_point = lobby_room_node.ExitPoint.global_position
			#prev_room = enemy_room_node
			#add_child(enemy_room_node)
		#else:
			#prev_connect_point = prev_room.ExitPoint.global_position
			#add_child(enemy_room_node)
			#prev_room = enemy_room_node
		#var next_connect_point : Vector2 = Vector2(prev_connect_point.x, prev_connect_point.y - 16)
		#var init_point : Vector2 = next_connect_point - enemy_room_node.StartPoint.global_position
		#enemy_room_node.global_position = init_point
	##ここに全生成した後BossRoomを生成
	#if room_dictionary[RoomType.Boss] == null:
		#return
	#prev_connect_point = prev_room.ExitPoint.global_position
	#var boss_room_scene : PackedScene = room_dictionary[RoomType.Boss].pick_random()
	#var boss_room : Room = boss_room_scene.instantiate()
	#add_child(boss_room)
	#var next_connect_point : Vector2 = Vector2(prev_connect_point.x, prev_connect_point.y - 16)
	#var init_point : Vector2 = next_connect_point - boss_room.StartPoint.global_position
	#boss_room.global_position = init_point
	#prev_room = boss_room
	##BossRoomを生成した後、EndRoomを生成する
	#if end_room_dir == null:
		#return
	#if room_dictionary[RoomType.End] == null:
		#return
	#prev_connect_point = prev_room.ExitPoint.global_position
	#var end_room_scene : PackedScene = room_dictionary[RoomType.End].pick_random()
	#var end_room : Room = end_room_scene.instantiate()
	#add_child(end_room)
	#next_connect_point = Vector2(prev_connect_point.x, prev_connect_point.y - 16)
	#init_point = next_connect_point - end_room.StartPoint.global_position
	#end_room.global_position = init_point
	#prev_room = end_room
	#
	##var second_room_node : Room = second_room.instantiate()
	##var prev_connect_point : Vector2 = first_room_node.ExitPoint.global_position
	###prev_connect_point = first_room_node.to_local(prev_connect_point)
	##add_child(second_room_node)
	 ##
	
	
	
	
