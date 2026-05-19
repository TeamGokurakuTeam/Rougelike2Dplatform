extends Node2D
class_name MainGame

@onready var player_ui: GameUI = $PlayerUI
@onready var player: Player = $Player

func _ready() -> void:
	player.pickup_item.connect(player_ui._on_character_pickup_item)
	player.pickup_modifier.connect(player_ui.mod_ui._on_player_pickup_modifier)

func _process(delta: float) -> void:
	pass
