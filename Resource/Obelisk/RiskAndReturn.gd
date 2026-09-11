extends Resource
class_name ObeliskResource

enum Difficult {
	Normal,
	Hard,
	Inferno
}

@export var difficult : Difficult = Difficult.Normal
@export var resource_id : String = ""
@export_multiline() var explanation_text : String
