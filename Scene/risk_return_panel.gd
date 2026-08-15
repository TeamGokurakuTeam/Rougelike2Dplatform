extends Panel
class_name RiskReturnPanel

@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var label_2: Label = $Label2

var gain_resource_id : String
var loss_resource_id : String

signal risk_return_selected(gain_resource_id, loss_resource_id)

func _ready() -> void:
	button.button_down.connect(_on_button_pressed)

func setup(gain_res_id : String, loss_res_id : String) -> void:
	if GlobalResourceLoader.gain_cache.has(gain_res_id) and GlobalResourceLoader.loss_cache.has(loss_res_id):
		var gain_res : ObeliskResource = GlobalResourceLoader.gain_cache[gain_res_id]
		var loss_res : ObeliskResource = GlobalResourceLoader.loss_cache[loss_res_id]
		gain_resource_id = gain_res.resource_id
		loss_resource_id = loss_res.resource_id
		label.text = gain_res.explanation_text
		label_2.text = loss_res.explanation_text
		
		button.disabled = false
	else:
		clean()

func clean() -> void:
	label.text = ""
	button.disabled = true

func _on_button_pressed() -> void:
	risk_return_selected.emit(gain_resource_id, loss_resource_id)
