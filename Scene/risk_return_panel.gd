extends Panel
class_name RiskReturnPanel

@onready var label: Label = $Label
@onready var button: Button = $Button

func setup(resource_id : String) -> void:
	if GlobalResourceLoader.obelisk_cache.has(resource_id):
		var res : ObeliskResource = GlobalResourceLoader.obelisk_cache[resource_id]
		label.text = res.explanation_text
		button.disabled = false
	else:
		clean()

func clean() -> void:
	label.text = ""
	button.disabled = true
