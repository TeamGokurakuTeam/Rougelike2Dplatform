extends CanvasLayer
class_name GameUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_character_pickup_item(player: Player) -> void:
	for i in get_children().size():
		var node : InventoryPanel = get_child(i)
		if i >= player.resource_ids.size() or i < 0:
			node.resource = null
		else:
			var resource : ResourceItem = GlobalResourceLoader.item_cache[player.resource_ids[i]]
			node.resource = resource
		node.update(player.current_weapon == i)
