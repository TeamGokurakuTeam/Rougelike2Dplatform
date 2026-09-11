extends Area2D
class_name MagicCircle

@export var pair_circle : MagicCircle
@export var stay_time : float = 3.0
@onready var anim : AnimationPlayer = $AnimationPlayer

var timer : float = 0.0
var player_inside : bool = false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta: float) -> void:
	if player_inside:
		timer += delta
		if timer >= stay_time:
			_teleport_player()
			timer = 0.0

func _on_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		player_inside = true
		timer = 0.0
		anim.play("Start")

func _on_body_exited(body : Node) -> void:
	if body.is_in_group("Player"):
		player_inside = false
		timer = 0.0
		anim.stop()

func _teleport_player() -> void:
	if pair_circle == null:
		return
	var player = get_overlapping_bodies().filter(func(b): return b.is_in_group("Player"))
	if player.size() == 0:
		return
	player[0].global_position = pair_circle.global_position
