extends Node2D

@onready var canvas_layer: GameUI = $CanvasLayer
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.pickup_item.connect(canvas_layer._on_character_pickup_item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
