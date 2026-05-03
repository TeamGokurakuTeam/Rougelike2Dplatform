extends Node2D
class_name Room

@export var StartPoint : Marker2D ## 前の層に繋げるためのポイント
@export var ExitPoint : Marker2D ## 後の層に繋げるためのポイント

@onready var tile_maps: Node2D = $TileMaps

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tilemap_size() -> Vector2:
	if tile_maps.get_child_count() <= 0:
		return Vector2.ZERO
	var result : Rect2
	var first_layer : TileMapLayer = tile_maps.get_child(0)
	for layer in tile_maps.get_children():
		var rect : Rect2 = (layer as TileMapLayer).get_used_rect()
		result = result.merge(rect)
	return result.size * first_layer.tile_set.tile_size.x
