class_name SaveData

## -playerのリソースid- ##
var p_weapon_resource_ids : Array[String] = [] #playerの所持してる武器たち
var p_mod_resource_ids : Array[String] = [] #playerの所持している修飾子たち

func InitData() -> void:
	p_weapon_resource_ids = []
	p_mod_resource_ids = []
