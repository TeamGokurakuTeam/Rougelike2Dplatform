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
	if body is not DropItem:
		return
	var drop_item : DropItem = body as DropItem
	var res : Resource = drop_item.resource
	if res == null:
		return

	if res is HealItemRes:
		character.hp_component.apply_heal((res as HealItemRes).heal_amount)
		body.queue_free()
	elif res is ResourceItem and character.weapon_resource_ids.size() <= 0:
		character.weapon_resource_ids.append((res as ResourceItem).Id)
		character.current_weapon = character.weapon_resource_ids.size() - 1
		character.update_weapon()
		body.queue_free()
	elif res is ModifierResource:
		character.mod_resource_ids.append((res as ModifierResource).modifier_id)
		character.update_modifier()
		character.modifier_picked_up.emit(res)
		body.queue_free()
