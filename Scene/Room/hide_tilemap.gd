extends TileMapLayer
class_name HideTileMap

@onready var area_2d: Area2D = $Area2D

var player : Player

func _ready() -> void:
	build_collision_from_tilemap()
	for node in get_children():
		var area2d : Area2D = node as Area2D
		area2d.connect("body_entered", _on_body_entered)
		area2d.connect("body_exited", _on_body_exited)
	(material as ShaderMaterial).set_shader_parameter("radius", 0)
	(material as ShaderMaterial).set_shader_parameter("softness", 0)

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		(material as ShaderMaterial).set_shader_parameter("radius", 50)
		(material as ShaderMaterial).set_shader_parameter("softness", 50)

func _on_body_exited(body : Node2D) -> void:
	if body is Player:
		(material as ShaderMaterial).set_shader_parameter("radius", 0)
		(material as ShaderMaterial).set_shader_parameter("softness", 0)

func build_collision_from_tilemap() -> void:
	# 既存のCollisionShapeがあれば削除(再生成対応)
	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()

	var used_cells: Array[Vector2i] = get_used_cells()

	for cell in used_cells:
		var tile_data: TileData = get_cell_tile_data(cell)
		if tile_data == null:
			continue

		var polygon_count: int = tile_data.get_collision_polygons_count(10)
		if polygon_count == 0:
			continue

		# セルのローカル座標(タイル1個分のオフセット)を計算
		var cell_local_pos: Vector2 = map_to_local(cell)

		for i in range(polygon_count):
			var points: PackedVector2Array = tile_data.get_collision_polygon_points(10, i)
			if points.is_empty():
				continue

			var collision_polygon := CollisionPolygon2D.new()
			# タイルのローカル座標に合わせて移動
			var offset_points := PackedVector2Array()
			for p in points:
				offset_points.append(p + cell_local_pos)
			collision_polygon.polygon = offset_points
			area_2d.add_child(collision_polygon)
