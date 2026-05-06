extends Character
class_name Enemy

const DROP_ITEM = preload("uid://dy6pxaf7y18u7")

@export var item_resource : Array[ResourceItem]

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	super(delta)
	if velocity.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif velocity.x <= 0 and not sprite.flip_h:
		sprite.flip_h = true

func _on_hp_component_is_dead() -> void:
	if item_resource != null:
		var drop_item : DropItem = DROP_ITEM.instantiate()
		drop_item.resource = item_resource.pick_random()
		get_tree().root.add_child(drop_item)
		drop_item.global_position = Vector2(self.global_position.x, self.global_position.y + 15)
	queue_free()
