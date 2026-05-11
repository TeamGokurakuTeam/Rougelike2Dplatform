extends StaticBody2D

@export var disable_time := 0.2
@onready var col: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sensor: Area2D = $Sensor

var player_inside := false
var player_body: Node2D = null
var current_time : =0.0

func _ready() -> void:
	sensor.body_entered.connect(_on_body_entered)
	sensor.body_exited.connect(_on_body_exited)

func _process(delta):
	if current_time > 0:
		current_time -= delta
		col.disabled = true
		return
	if player_inside and player_body:
		var py = player_body.global_position.y
		var platform_top = global_position.y - col.shape.extents.y
		if py < platform_top:
			col.disabled = false
		else:
			col.disabled = true
	else:
		col.disabled = false

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = true
	player_body = body
	if body.velocity.y > 0:
		current_time = disable_time
		col.disabled = true

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_inside = false
	player_body = null
	if current_time <= 0:
		col.disabled = false
