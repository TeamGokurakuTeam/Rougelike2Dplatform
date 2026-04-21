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

func _on_area_entered(area: Area2D) -> void:
	if area is DropItem:
		character.resource_ids.append((area as DropItem).resource.Id)
		var weapon = (area as DropItem).resource.WeaponScene.instantiate()
		character.inventory.add_child(weapon)
