extends Enemy
class_name DarkSamurai

func _process(delta: float) -> void:
	print(hp_component.hp)

func _on_hp_component_is_dead() -> void:
	if item_resource != null:
		var drop_item : DropItem = DROP_ITEM.instantiate()
		drop_item.resource = item_resource.pick_random()
		get_tree().root.add_child(drop_item)
		drop_item.global_position = Vector2(self.global_position.x, self.global_position.y + 15)
	queue_free()
