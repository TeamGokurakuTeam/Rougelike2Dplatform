extends Node

@export_dir var items_folder : Array[String]

var item_cache : Dictionary = {}

func _ready() -> void:
	for folder in items_folder:
		file_load(folder, item_cache)

func file_load(folder_path : String, res_cache : Dictionary) -> void:
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
