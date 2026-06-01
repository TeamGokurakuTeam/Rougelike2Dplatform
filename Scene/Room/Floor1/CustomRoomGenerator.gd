@tool
extends EdgarRenderer2D

const DOOR = preload("uid://cmin4ppf3tbti")

func _post_process(tile_map_layer: TileMapLayer, tiled_layer: String) -> void:
	# Custom per-layer post-processing
	pass

func _marker_post_process(tile_map_layer: TileMapLayer, marker: Node, data: Variant) -> void:
	pass

func _custom_post_process(tile_map_layer: TileMapLayer, layer: Node) -> void:
	pass

func _clear_tiles(tile_map_layer: TileMapLayer) -> void:
	# Custom tile clearing behavior
	# Default implementation: tile_map_layer.clear()
	pass
