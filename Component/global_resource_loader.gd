extends Node

@export_dir var items_folder : Array[String]
@export var room_folder : Dictionary[RoomInfoResource.FloorType, String]
@export_dir var gain_folder : Array[String]
@export_dir var loss_folder : Array[String]
@export_dir var modifier_folder : Array[String]

#Global変数なのでこれはよそで使ってもよい
#使用例:Sword.resource = weapon_cache["DebugSword"]
var weapon_cache : Dictionary[String, Resource] = {}
var modifier_cache : Dictionary[String, Resource] = {}

#room_cacheのintはバイナリ(0101のやつ)、第二はRoomResのArrayとして用意している
var room_cache : RoomDatabase = RoomDatabase.new()
var gain_cache : Dictionary[String, ObeliskResource] = {}
var loss_cache : Dictionary[String, ObeliskResource] = {}

func _ready() -> void:
	for folder in items_folder:
		_file_load(folder, weapon_cache)
	for floor_type in room_folder.keys():
		_file_room_load(floor_type, room_folder[floor_type], room_cache)
	for folder in gain_folder:
		_file_load(folder, gain_cache)
	for folder in loss_folder:
		_file_load(folder, loss_cache)
	for folder in modifier_folder:
		_file_load(folder, modifier_cache)

#下の関数はprivateでここのAutoload専用の関数なのでよそで使わないこと
func _file_load(folder_path : String, res_cache : Dictionary) -> void:
	var folder : DirAccess = DirAccess.open(folder_path)
	
	folder.list_dir_begin()
	
	var file_name : String = folder.get_next()
	
	if folder_path != null:
		while file_name != "":
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_prefix(".remap")
				
			var resource : Resource = load(folder_path + "/" + file_name)
			
			
			var result = file_name.split(".")[0]
			
			res_cache[result] = resource
			
			file_name = folder.get_next()

#room専用のファイル読み込み関数
func _file_room_load(floor_type : RoomInfoResource.FloorType, folder_path : String, res_cache : RoomDatabase) -> void:
	const subfolder_names : Array[String] = ["Boss", "End", "Enemy", "Lobby", "Shop", "Secret"]

	for subfolder_name in subfolder_names:
		var current_folder_path : String = "%s/%s" % [folder_path, subfolder_name]
		var folder : DirAccess = DirAccess.open(current_folder_path)
		if folder == null:
			continue

		folder.list_dir_begin()
		var file_name : String = folder.get_next()
		while file_name != "":
			if file_name.ends_with(".remap"):
				file_name = file_name.trim_prefix(".remap")

			var resource : Resource = load(current_folder_path + "/" + file_name)
			res_cache.add_room_data(resource, floor_type)
			file_name = folder.get_next()
		folder.list_dir_end()
