extends DropItem
class_name DropHealItem

@export var item_res : HealItemRes

func _ready() -> void:
	if item_res != null:
		sprite_2d.texture = item_res.texture
