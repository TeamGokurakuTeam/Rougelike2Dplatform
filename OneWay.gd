extends StaticBody2D
class_name OneWayPlatform

@onready var col: CollisionShape2D = $CollisionShape2D
@onready var sensor: Area2D = $Sensor
@onready var player: Player = get_tree().get_first_node_in_group("Player")

var player_inside: bool = false
var player_body: Player = null
var player_touching := false

func _ready() -> void:
	sensor.body_entered.connect(_on_body_entered)
	sensor.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if player_inside and player_body:
		var py: float = player_body.global_position.y
		var top_offset: float = float(col.shape.extents.y)
		var platform_top: float = global_position.y - top_offset
		col.disabled = py >= platform_top
	else:
		col.disabled = false
	if player_touching and Input.is_action_just_pressed("UI_Down"):
		set_collision_layer_value(8, false)
		_restore_layer()

func _restore_layer() -> void:
	await get_tree().create_timer(0.5).timeout
	set_collision_layer_value(8, true)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_touching = true
		player_inside = true
		player_body = body

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_touching = false
		player_inside = false
		player_body = null
