extends Node2D

@export var pull_strength : float = 550.0
@export var on_time : float = 2.0
@export var off_time : float = 2.0

@onready var wind_area: Area2D = $WindArea
@onready var fan_point: Node2D = $FanPoint
@onready var anim : AnimationPlayer = $AnimationPlayer

var is_on : bool = false
var timer : float = 0.0
var current_limit : float = 0.0
var player : Node = null


func _ready() -> void:
	wind_area.connect("body_entered",Callable(self, "_on_body_entered"))
	wind_area.connect("body_exited",Callable(self, "_on_body_exited"))
	_set_off()

func _process(delta: float) -> void:
	timer += delta
	if timer >= current_limit:
		if is_on:
			_set_off()
		else:
			_set_on()
			
	if is_on and player:
		_pull_player(delta)

func _set_on() -> void:
	is_on = true
	timer = 0.0
	current_limit = on_time
	wind_area.monitoring = true
	anim.play("FanOn")

func _set_off() -> void:
	is_on = false
	timer = 0.0
	current_limit = off_time
	wind_area.monitoring = true
	player = null
	anim.stop()

func _on_body_entered(body : Node) -> void:
	if body.is_in_group("Player"):
		player = body

func  _on_body_exited(body : Node) -> void:
	if body == player:
		player = null

func _pull_player(delta : float) -> void:
	var dir: Vector2 = (fan_point.global_position - player.global_position).normalized()
	var force: Vector2 = dir * pull_strength * delta
	if player.has_method("add_external_force"):
		player.add_external_force(force)
