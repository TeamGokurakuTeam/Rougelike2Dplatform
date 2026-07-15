extends Resource
class_name ObeliskResource

enum Difficult {
	Normal,
	Hard,
	Inferno
}

@export var difficult : Difficult = Difficult.Normal
@export var name : String = "" ##こっちは名前(日本語可)を書く
@export var resource_id : String = "" ##こっちは英語で書く。基本Resの名前で良し。
@export_multiline() var explanation_text : String
