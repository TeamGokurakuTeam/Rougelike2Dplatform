extends Resource
class_name ResourceItem

@export var Sprite : Texture
@export var Id : String
@export var Name : String
@export var WeaponScene : PackedScene
@export_enum("common", "uncommon", "rare", "Master", "DreaM", ) var Rarities : String = "common" 
