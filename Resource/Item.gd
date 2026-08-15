extends Resource
class_name ResourceItem

@export var Sprite : Texture ##武器の画像を貼る
@export var Id : String ##参照するための武器のID。これは英名で書いてください。
@export var Name : String ##武器の表示名。日本語でも英語でも大丈夫。
@export var WeaponScene : PackedScene ##武器を出すためのシーン。武器のシーンを配置してください。
@export var MergeResultWeaponId : String ##合成した時の武器先のID。これは英名で書いてください。
@export_enum("common", "uncommon", "rare", "Master", "DreaM", ) var Rarities : String = "common" 
@export_multiline var explanation : String ##武器の攻撃の説明
@export_multiline var flavor_text : String ##武器のフレーバーテキスト
@export_multiline var unlock_text : String ##武器の解禁条件
