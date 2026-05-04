extends State
class_name KnightShield

@export var animation_player: AnimationPlayer
@export var parent: Knight
@export var hurtbox: Hurtbox
@export var shield_hitbox: Area2D

func _ready() -> void:
	if not shield_hitbox.area_entered.is_connected(_on_shield_hitbox_area_entered):
		shield_hitbox.area_entered.connect(_on_shield_hitbox_area_entered)

	if not hurtbox.area_entered.is_connected(_on_hurtbox_area_entered):
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func Enter() -> void:
	parent.is_shielding = true 
	animation_player.play("Shield")

	if shield_hitbox:
		shield_hitbox.monitoring = true

		var shape := shield_hitbox.get_node("CollisionShape2D")
		shape.set_deferred("disabled", false) 

		print("=== ShieldHitbox Debug ===")
		print("layer =", shield_hitbox.collision_layer)
		print("mask =", shield_hitbox.collision_mask)

func Exit() -> void:
	parent.is_shielding = false 

	if shield_hitbox:
		var shape := shield_hitbox.get_node("CollisionShape2D")
		shape.set_deferred("disabled", true) 

func Update(delta) -> void:
	if not animation_player.is_playing():
		StateTransitioned.emit(self, "NearAttack")

func Physics_Update(delta) -> void:
	pass


func _on_shield_hitbox_area_entered(area: Area2D) -> void:
	StateTransitioned.emit(self, "ShieldBash")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("=== Hurtbox area_entered ===")
	print("触れた相手:", area.name)
