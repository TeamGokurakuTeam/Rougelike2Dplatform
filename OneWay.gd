extends StaticBody2D
class_name OneWayPlatform

@export var disable_time : float = 0.2
@onready var col: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sensor: Area2D = $Sensor

#
@onready var one_way: StaticBody2D
#
@export var player_coll : Player 


var player_inside : bool = false
var player_body : Node2D = null
var current_time : float =0.0

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
		#
		if player_coll:
			set_collision_mask_value(1, false)
			one_way.collision_layer




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
