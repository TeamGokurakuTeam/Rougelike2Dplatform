extends Node2D

@onready var drop_item: DropItem = $DropItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_item.resource = GlobalResourceLoader.item_cache["DebugSword"]
	drop_item.sprite_2d.texture = drop_item.resource.Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
