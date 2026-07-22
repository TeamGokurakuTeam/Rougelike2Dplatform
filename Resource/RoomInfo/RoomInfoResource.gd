extends Resource
class_name RoomInfoResource

@export var room_scene : PackedScene
@export var room_type : RoomType

enum RoomType {
	LOBBY_ROOM,
	ENEMY_ROOM,
	BONUS_ROOM,
	SHOP_ROOM,
	BOSS_ROOM,
	END_ROOM
}

@export var up : bool
@export var down : bool
@export var left : bool
@export var right : bool
