extends Resource
class_name ModifierResource

@export_enum("rank1","rank2","rank3") var ModifierRank : int = 0 ## 高ければ高いほど良い修飾子になる
@export var texture : Texture2D ## チケットのテクスチャ
@export var modifier_id : String ## 英語で書く
@export var modifier_name : String ## 日本語で書いても良い
@export var color_rarity : Color = Color("ffffff") ## 修飾子の色を決める
@export_multiline var explanation : String ## 武器に着いた時の修飾子効果の説明について
@export var price : int = 1
