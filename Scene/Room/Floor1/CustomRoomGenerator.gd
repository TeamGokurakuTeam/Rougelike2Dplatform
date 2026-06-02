@tool
extends EdgarRenderer2D
class_name DungeonGeneratorFloor1

var player_spawn_coordinate : Vector2

func _post_process(tile_map_layer: TileMapLayer, tiled_layer: String) -> void:
	# Custom per-layer post-processing
	pass

func _marker_post_process(tile_map_layer: TileMapLayer, marker: Node, data: Variant) -> void:
	if marker.name == "PlayerMarker":
		player_spawn_coordinate = marker.position

func _custom_post_process(tile_map_layer: TileMapLayer, layer: Node) -> void:
	pass

func _clear_tiles(tile_map_layer: TileMapLayer) -> void:
	# Custom tile clearing behavior
	# Default implementation: tile_map_layer.clear()
	pass
