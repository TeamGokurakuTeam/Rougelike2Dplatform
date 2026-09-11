extends RefCounted
class_name RoomDatabase

var all_rooms : Array[RoomInfoResource] = []

var by_direction : Dictionary[int, Array] = {}
var by_room_type : Dictionary[RoomInfoResource.RoomType, Array] = {}
var by_floor_type : Dictionary[RoomInfoResource.FloorType, Array] = {}

var by_combo : Dictionary[String, Array] = {}

func add_room_data(room_info : Resource, floor_type : RoomInfoResource.FloorType) -> void:
	if room_info is not RoomInfoResource:
		return
	all_rooms.append(room_info)
	
	var direction : int = _calculate_direction(room_info)
	_add_to_dictionary(by_direction, room_info, direction)
	_add_to_dictionary(by_room_type, room_info, room_info.room_type)
	_add_to_dictionary(by_floor_type, room_info, floor_type)
	
	var key : String = _get_combo(room_info.room_type, floor_type, direction)
	_add_to_dictionary(by_combo, room_info, key)
	
func _calculate_direction(room_info : RoomInfoResource) -> int:
	var mask : int = 0
	if room_info.up:
		mask |= Common.UP_MASK
	if room_info.down:
		mask |= Common.DOWN_MASK
	if room_info.left:
		mask |= Common.LEFT_MASK
	if room_info.right:
		mask |= Common.RIGHT_MASK
	return mask

func _add_to_dictionary(dict : Dictionary, room_info : RoomInfoResource, key) -> void:
	if not dict.has(key):
		dict[key] = [] 
	dict[key].append(room_info)

func _get_combo(room_type : RoomInfoResource.RoomType,
				floor_type : RoomInfoResource.FloorType,
				direction : int) -> String:
	return "%s|%s|%s" % [room_type, floor_type, direction]

func query(room_type : Variant = null,
		   floor_type : Variant = null,
		   direction : Variant = null) -> Array[RoomInfoResource]:
	# 引数Variantにすることでnullをサポートする
	# intとenumはnull使えない
	if room_type != null and floor_type != null and direction!= null:
		var key : String = _get_combo(room_type, floor_type, direction)
		var result : Array[RoomInfoResource] = []
		result.assign(by_combo.get(key, []))
		return result

	var search : Array = []
	if room_type != null:
		search.append(by_room_type.get(room_type, []))
	if floor_type != null:
		search.append(by_floor_type.get(floor_type, []))
	if direction != null:
		search.append(by_direction.get(direction, []))

	if search.is_empty():
		var result : Array[RoomInfoResource] = []
		return result
	
	search.sort_custom(func(a, b): return a.size() < b.size())
	var result : Array = search[0].duplicate()
	for i in range(1, search.size()):
		var lookup : Dictionary = {}
		for res in search[i]:
			lookup[res] = true
		result = result.filter(func(res): return lookup[res])

	return result
