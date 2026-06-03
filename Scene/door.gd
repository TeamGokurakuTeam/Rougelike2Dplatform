extends StaticBody2D
class_name Door

@onready var player_detector: CollisionShape2D = $PlayerDetector/CollisionShape2D

@export var dir : Direction = Direction.NONE #NONEは初期値用

var teleport_to : Vector2

enum Direction {
	NONE,
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
