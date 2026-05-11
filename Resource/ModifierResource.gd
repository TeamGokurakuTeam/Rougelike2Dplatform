extends Resource
class_name ModifierResource

@export var modifier_id : String ## 英語で書く
@export var modifier_name : String ## 日本語で書いても良い
@export var color_rarity : Color = Color("ffffff") ## 修飾子の色を決める
@export_multiline var explanation : String ## 武器に着いた時の修飾子効果の説明について
