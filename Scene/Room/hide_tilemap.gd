extends TileMapLayer
class_name HideTileMap

@export var hide_radius : float = 40.0 ## 隠しタイルに入った時に表示される丸の範囲。これを多くすると、半径が大きくなる。
@export var hide_softness : float = 20.0 ## 隠しタイルに入った時に表示される丸にたいしてのぼかしの量。これを多くすると、より円の縁がぼける。

@onready var area_2d: Area2D = $Area2D

var player : Player
var tween : Tween

func _ready() -> void:
	build_collision_from_tilemap()
	for node in get_children():
		var area2d : Area2D = node as Area2D
		area2d.connect("body_entered", _on_body_entered)
		area2d.connect("body_exited", _on_body_exited)
	(material as ShaderMaterial).set_shader_parameter("radius", 0)
	(material as ShaderMaterial).set_shader_parameter("softness", 0)

func _process(delta: float) -> void:
	if player != null:
		(material as ShaderMaterial).set_shader_parameter("reveal_position", player.global_position)

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.parallel()
		tween.tween_property(self.material, "shader_parameter/radius", hide_radius, 0.5)
		(material as ShaderMaterial).set_shader_parameter("softness", hide_softness)
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _on_body_exited(body : Node2D) -> void:
	if body is Player:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.parallel()
		tween.tween_property(self.material, "shader_parameter/radius", 0, 0.4)
		tween.tween_property(self.material, "shader_parameter/softness", 0, 0.4)
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

func build_collision_from_tilemap() -> void:
	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()

	var used_cells: Array[Vector2i] = get_used_cells()

	for cell in used_cells:
		var tile_data: TileData = get_cell_tile_data(cell)
		if tile_data == null:
			continue

		var polygon_count: int = tile_data.get_collision_polygons_count(0)
		if polygon_count == 0:
			continue

		var cell_local_pos: Vector2 = map_to_local(cell)

		for i in range(polygon_count):
			var points: PackedVector2Array = tile_data.get_collision_polygon_points(0, i)
			if points.is_empty():
				continue

			var collision_polygon := CollisionPolygon2D.new()
			# タイルのローカル座標に合わせて移動
			var offset_points := PackedVector2Array()
			for p in points:
				offset_points.append(p + cell_local_pos)
			collision_polygon.polygon = offset_points
			area_2d.add_child(collision_polygon)
