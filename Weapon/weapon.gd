extends Node2D
class_name Weapon

@export var resource_id : String

@onready var charge_particle: GPUParticles2D = $ChargeParticle
@onready var root: Node2D = $Root
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Root/Sprite2D

var mouse_direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UI_Attack") and not animation_player.is_playing():
		animation_player.play("Charge")
	elif Input.is_action_just_released("UI_Attack"):
		if animation_player.is_playing() and animation_player.current_animation == "Charge":
			animation_player.play("Attack")
		elif charge_particle.emitting:
			animation_player.play("StrongAttack")
	
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if not animation_player.is_playing() or animation_player.current_animation == "charge":
		root.rotation = mouse_direction.angle()
		if root.scale.y == 1 and mouse_direction.x < 0:
			root.scale.y = -1
		elif root.scale.y == -1 and mouse_direction.x > 0:
			root.scale.y = 1
	
	root.rotation = mouse_direction.angle()

#func move(mouse_direction: Vector2) -> void:
	#if ranged_weapon:
		#rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	#else:
		#if not animation_player.is_playing() or animation_player.current_animation == "charge":
			#rotation = mouse_direction.angle()
			#hitbox.knockback_direction = mouse_direction
			#if scale.y == 1 and mouse_direction.x < 0:
				#scale.y = -1
			#elif scale.y == -1 and mouse_direction.x > 0:
				#scale.y = 1

func _physics_process(delta: float) -> void:
	pass
