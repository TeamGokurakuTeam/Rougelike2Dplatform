extends State
class_name KnightShield

@export var animation_player: AnimationPlayer
@export var parent: Knight
@export var hurtbox: Hurtbox
@export var shield_hitbox: Area2D

var shape: CollisionShape2D

func _ready() -> void:
	shape = shield_hitbox.get_node("CollisionShape2D")
	if not shield_hitbox.area_entered.is_connected(_on_shield_hitbox_area_entered):
		shield_hitbox.area_entered.connect(_on_shield_hitbox_area_entered)

func Enter() -> void:
	parent.is_shielding = true 
	animation_player.play("Shield")
	if shield_hitbox:
		shield_hitbox.monitoring = true
		shape.set_deferred("disabled", false) 

func Exit() -> void:
	parent.is_shielding = false 
	if shield_hitbox:
		shape.set_deferred("disabled", true) 

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "NearAttack")

func Physics_Update(delta) -> void:
	pass

func _on_shield_hitbox_area_entered(area: Area2D) -> void:
	StateTransitioned.emit(self, "ShieldBash")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	pass
