extends Node2D
class_name MainGame

@onready var player_ui: GameUI = $PlayerUI
@onready var player: Player = $Player
@onready var generator: EdgarRenderer2D = $Generator

func _ready() -> void:
	player_ui.player = player
	player_ui.player_hp_ui.player = player
	player.pickup_item.connect(player_ui._on_character_pickup_item)
	player.pickup_modifier.connect(player_ui.mod_ui._on_player_pickup_modifier)
	player.applied_modifier.connect(player_ui.modifier_timer._on_player_applied_modifier)
	player.hp_component.hp_changed.connect(player_ui.player_hp_ui._on_player_hp_changed)
	for node in generator.get_children():
		generator.clear(node)
	generator.generate_layout()
	generator.render()
	
func _process(delta: float) -> void:
	pass
