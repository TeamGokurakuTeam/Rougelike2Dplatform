extends Panel
class_name RiskReturnPanel

@onready var label: Label = $Label
@onready var button: Button = $Button
@onready var label_2: Label = $Risk/Label2

var gain_resource_id : String
var loss_resource_id : String

signal risk_return_selected(gain_resource_id, loss_resource_id)

func _ready() -> void:
	button.button_down.connect(_on_button_pressed)

func setup(gain_resource_id : String, loss_resource_id : String) -> void:
	if GlobalResourceLoader.obelisk_cache.has(gain_resource_id):
		var gain_res : ObeliskResource = GlobalResourceLoader.obelisk_cache[gain_resource_id]
		var loss_res : ObeliskResource = GlobalResourceLoader.obelisk_cache[loss_resource_id]
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
