extends Panel
class_name ModifierExplanationUI

@export_multiline() var text : String

@onready var texture_rect : TextureRect = $Icon/TextureRect
@onready var rich_text_label : RichTextLabel = $RichTextLabel
@onready var timer : Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var modifier_resource : ModifierResource
var count : int = 0
var propetytween : PropertyTweener
var tween : Tween

func _process(delta: float) -> void:
	pass

func submit(text:String, scroll_second : float):
	#count += 1
	rich_text_label.clear()
	rich_text_label.add_text(text)
	rich_text_label.newline()
	# これがないと一度に10行程度入力した時に最下行までスクロールしません
	rich_text_label.get_line_count()
	var bar:VScrollBar = rich_text_label.get_v_scroll_bar()
	bar.visible = false
	await get_tree().create_timer(1.5).timeout
	if(tween != null):
		tween.kill()
	tween = get_tree().create_tween()
	propetytween = tween.tween_property(bar, "value", bar.max_value, scroll_second)
