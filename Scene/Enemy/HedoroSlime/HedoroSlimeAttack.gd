extends State
class_name HedoroSlimeAttack

@export var parent : HedoroSlime
@export var anim_player : AnimationPlayer

func Enter() -> void:
	anim_player.play("Attack")
	if parent.player_dir() > 0:
		parent.hitbox.scale.x = 1
	elif parent.player_dir() < 0:
		parent.hitbox.scale.x = -1

func Exit() -> void:
	pass

func Update(delta) -> void:
	if parent.hitbox.scale.x == -1:
		parent.sprite.flip_h = true
	elif parent.hitbox.scale.x == 1:
		parent.sprite.flip_h = false
		
	if not anim_player.is_playing():
		StateTransitioned.emit(self, "Idle")

func Physics_Update(delta) -> void:
	pass

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and anim_player.is_playing():
		parent.is_player_entered = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body is Player:
		parent.is_player_entered = false
