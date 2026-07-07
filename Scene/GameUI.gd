extends CanvasLayer
class_name GameUI

@onready var hotbar: HBoxContainer = $Hotbar
@onready var mod_ui: ModUI = $ModUI
@onready var modifier_timer: ModifierTimer = $ModifierTimer
@onready var player_hp_ui: PlayerHpUI = $PlayerHpUI
@onready var locked_mod_label: Label = $LockedModLabel
@onready var modifier_explanation: ModifierExplanationUI = $ModifierExplanation

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_scroll_left"):
		player.current_modifier += 1
		mod_ui.texture_update(player)
	if Input.is_action_just_pressed("UI_scroll_right"):
		player.current_modifier -= 1
		mod_ui.texture_update(player)

func _on_character_modifier_updated(player: Player) -> void:
	for i in hotbar.get_children().size():
		var node : InventoryPanel = hotbar.get_child(i)
		if i >= player.weapon_resource_ids.size() or i < 0:
			node.resource = null
		else:
			var resource : ResourceItem = GlobalResourceLoader.item_cache[player.weapon_resource_ids[i]]
			node.resource = resource
		node.update(player.current_weapon == i)

func _on_modifier_picked_up(mod_res : ModifierResource) -> void:
	modifier_explanation.modifier_resource = mod_res
	modifier_explanation.submit(mod_res.explanation, 5.0)
	modifier_explanation.animation_player.play("Start")
	await get_tree().create_timer(6).timeout
	modifier_explanation.animation_player.play("End")
