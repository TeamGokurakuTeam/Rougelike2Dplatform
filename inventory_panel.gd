extends Panel
class_name InventoryPanel

@export var resource : ResourceItem

@onready var select: Panel = $Select
@onready var texture_rect: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update(isSelect : bool = false) -> void:
	if resource != null:
		texture_rect.texture = resource.Sprite
	else:
		texture_rect.texture = null
	select.visible = isSelect
