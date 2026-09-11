extends Node2D
class_name RoomGenerator

const ROOM_DISTANCE : int = 5000

@export_category("生成する部屋の数")
@export var generate_room_value : int = 6

var lobby_room : Room
var secret_room : Room
var main_game_node : MainGame

func room_generate(floor_layout : FloorLayoutResource = null, floor_type : Variant = null) -> void:
	if floor_layout != null:
		_generate_from_layout(floor_layout)
	else:
		_generate_random_floor(floor_type)

func _generate_random_floor(floor_type : Variant = null) -> void:
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

	var found_lobby_room : Room = null

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

			var query : Array = GlobalResourceLoader.room_cache.query(room_type, floor_type, room_opening)
			if query.is_empty() and floor_type != null:
				query = GlobalResourceLoader.room_cache.query(room_type, null, room_opening)

			var room_res : RoomInfoResource = query.pick_random()
			var room_node : Room = _place_room(room_res.room_scene, i, j)
			room_node.room_type = room_type
			room_data[i][j] = room_node
			if room_type == RoomInfoResource.RoomType.LOBBY_ROOM:
				found_lobby_room = room_node

	_connect_rooms(room_data)
	lobby_room = found_lobby_room
	_assign_room_depth()

	if floor_type == RoomInfoResource.FloorType.FLOOR1:
		var query = GlobalResourceLoader.room_cache.query(RoomInfoResource.RoomType.SECRET_ROOM, floor_type)
		if not query.is_empty():
			var secret_res = query.pick_random()
			secret_room = _place_room(secret_res.room_scene, -1, -1)
			secret_room.room_type = RoomInfoResource.RoomType.SECRET_ROOM
			
			var lobby_door : Door = found_lobby_room.get_door(Door.Direction.RIGHT)
			var secret_door : Door = secret_room.doors.get_child(0)
			if secret_door and lobby_door:
				secret_door.teleport_to = lobby_door

# 固定ステージの生成
func _generate_from_layout(layout : FloorLayoutResource) -> void:
	var room_data : Array[Array] = []
	for i in layout.rows:
		room_data.append([])
		for j in layout.columns:
			room_data[i].append(null)

	var found_lobby_room : Room = null

	for entry in layout.room_entries:
		if entry.room_info == null or entry.room_info.room_scene == null:
			continue
		var room_node : Room = _place_room(entry.room_info.room_scene, entry.row, entry.column)
		room_data[entry.row][entry.column] = room_node
		if entry.is_lobby:
			found_lobby_room = room_node
		room_node.room_type = entry.room_info.room_type

	_connect_rooms(room_data)
	lobby_room = found_lobby_room

func _place_room(room_scene : PackedScene, row : int, column : int) -> Room:
	var room_node : Room = room_scene.instantiate()
	room_node.main_game_node = self.main_game_node
	add_child(room_node)
	room_node.global_position = Vector2(column * ROOM_DISTANCE, row * ROOM_DISTANCE)
	return room_node

#room_dataの中身をドアでつなぐ(ランダム生成/固定フロア共通)
func _connect_rooms(room_data : Array[Array]) -> void:
	var rows_count : int = room_data.size()
	for i in rows_count:
		var columns_count : int = room_data[i].size()
		for j in columns_count: #今回のケースはiが縦、jが横
			var room : Room = room_data[i][j]
			if room == null:
				continue
			for k in room.doors.get_children():
				var door : Door = k as Door
				var other_room : Room = null
				match door.dir:
					Door.Direction.UP:
						if i - 1 >= 0:
							other_room = room_data[i - 1][j]
					Door.Direction.DOWN:
						if i + 1 < rows_count:
							other_room = room_data[i + 1][j]
					Door.Direction.LEFT:
						if j - 1 >= 0:
							other_room = room_data[i][j - 1]
					Door.Direction.RIGHT:
						if j + 1 < columns_count:
							other_room = room_data[i][j + 1]
				if other_room == null:
					continue
				var other_door : Door = other_room.get_door(Door.get_opposite_dirction(door.dir))
				Door.connect_door(door, other_door)

func clear_rooms() -> void:
	for node in get_children():
		node.queue_free()

func _reset_room_depth() -> void:
	for node in get_children():
		if node is Room:
			(node as Room).depth = -1

func _dfs_depth(room : Room, current_depth : int) -> void:
	if room == null or (room.depth >= 0 and room.depth <= current_depth):
		return
	room.depth = current_depth
	for node in room.doors.get_children():
		if node is not Door:
			return
		var door : Door = node as Door
		if door.teleport_to and door.teleport_to.current_room:
			_dfs_depth(door.teleport_to.current_room, current_depth + 1)

func _assign_room_depth() -> void:
	_reset_room_depth()
	_dfs_depth(lobby_room, 0)
