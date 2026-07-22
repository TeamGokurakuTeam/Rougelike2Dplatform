extends Area2D
class_name PickupComponent

@export var character : Player
@export var isDisabled : bool = false

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isDisabled:
		collision_shape_2d.disabled = true
	else:
		collision_shape_2d.disabled = false

func _on_body_entered(body: Node2D) -> void:
	if body is DropWeapon and character.weapon_resource_ids.size() <= 0:
		character.weapon_resource_ids.append((body as DropWeapon).resource.Id)
		character.current_weapon = character.weapon_resource_ids.size() - 1
		character.merge_weapon((body as DropWeapon).resource.Id)
		character.update_weapon()
		body.queue_free()
	
	if body is DropModifier:
		var drop_modifier : DropModifier = (body as DropModifier)
		if drop_modifier == null and drop_modifier.modifier == null:
			return
		character.mod_resource_ids.append(drop_modifier.modifier.modifier_id)
		character.update_modifier()
		character.modifier_picked_up.emit(drop_modifier.modifier)
		body.queue_free()
