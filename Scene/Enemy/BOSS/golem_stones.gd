extends Node2D
class_name GolemStones

@onready var stones: Node2D = $Stone
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	animation_player.play("Start")
	for node in stones.get_children():
		var rock : CharaProjectile = node as CharaProjectile
		rock.speed = 0
		var tween : Tween
		tween = create_tween()
		tween.set_loops()
		tween.tween_property(rock.sprite, "rotation_degrees", randf_range(-360, 360), 10)

func _process(delta: float) -> void:
	for node in stones.get_children():
		var rock : CharaProjectile = node as CharaProjectile
		rock.velocity = rock.direction * rock.speed

func _stone_shoot() -> void:
	for node in stones.get_children():
		var rock : CharaProjectile = node as CharaProjectile
		var player : Player = get_tree().get_first_node_in_group("Player")
		var dir : Vector2
		if player:
			dir = (player.global_position - global_position).normalized()
		else:
			dir = Vector2.RIGHT.rotated(deg_to_rad(randf_range(0, 360)))
		var tween : Tween
		tween = create_tween()
		tween.set_parallel()
		rock.direction = dir
		tween.tween_property(rock, "speed", 1200, 1.0)
		tween.tween_property(rock.hitbox, "damage", 10, 2.0)
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		await get_tree().create_timer(0.6).timeout
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
