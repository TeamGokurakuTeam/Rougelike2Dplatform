extends Character
class_name Enemy

const DROP_ITEM = preload("uid://dy6pxaf7y18u7")
const DROP_MODIFIER = preload("uid://b47iwp7p6b4wk")

@export var item_resource : Array[ResourceItem]
@export var mod_resource : Array[ModifierResource]

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitboxes: Node2D = $Hitboxes

var hitboxes_array : Array[Hitbox]

func _ready() -> void:
	for node in hitboxes.get_children():
		if node is not Hitbox:
			return
		hitboxes_array.append(node)

func _physics_process(delta: float) -> void:
	super(delta)
	if velocity.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif velocity.x <= 0 and not sprite.flip_h:
		sprite.flip_h = true

func _on_hp_component_is_dead() -> void:
	#killed_drop_item()
	killed_drop_modifier()
	queue_free()

func killed_drop_modifier() -> void:
	if mod_resource != null:
		var drop_mod : DropModifier = DROP_MODIFIER.instantiate()
		drop_mod.modifier = mod_resource.pick_random()
		get_tree().root.add_child(drop_mod)
		drop_mod.global_position = Vector2(self.global_position)

func killed_drop_item() -> void:
	if item_resource != null:
		var drop_item : DropItem = DROP_ITEM.instantiate()
		drop_item.resource = item_resource.pick_random()
		get_tree().root.add_child(drop_item)
		drop_item.global_position = Vector2(self.global_position.x, self.global_position.y + 15)

func increment_damage(value : float) -> void:
	for i in hitboxes_array.size():
		hitboxes_array[i].damage += value
