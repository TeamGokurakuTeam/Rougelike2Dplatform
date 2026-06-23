extends CanvasLayer
class_name GameUI

@onready var hotbar: HBoxContainer = $Hotbar
@onready var mod_ui: ModUI = $ModUI
@onready var modifier_timer: ModifierTimer = $ModifierTimer
@onready var player_hp_ui: PlayerHpUI = $PlayerHpUI

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_scroll_left"):
		player.current_modifier += 1
		mod_ui.texture_update(player)
	if Input.is_action_just_pressed("UI_scroll_right"):
		player.current_modifier -= 1
		mod_ui.texture_update(player)

func _on_character_pickup_item(player: Player) -> void:
	for i in hotbar.get_children().size():
		var node : InventoryPanel = hotbar.get_child(i)
		if i >= player.weapon_resource_ids.size() or i < 0:
			node.resource = null
		else:
			var resource : ResourceItem = GlobalResourceLoader.item_cache[player.weapon_resource_ids[i]]
			node.resource = resource
		node.update(player.current_weapon == i)
