extends Node2D
class_name Weapon

@export var resource_id : String

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Root/Sprite2D

var mouse_direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Attack") and !animation_player.is_playing():
		animation_player.play("Attack")
	
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and sprite_2d.flip_h:
		#マウスの方向が右側にあったら
		sprite_2d.flip_h = false
	elif mouse_direction.x < 0 and not sprite_2d.flip_h:
		#マウスの方向が左側にあったら
		sprite_2d.flip_h = true
	
	self.rotation = mouse_direction.angle()
	

func _physics_process(delta: float) -> void:
	pass
