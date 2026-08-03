extends Control
class_name WeaponSelectMenu

const WEAPON_SELECT_PANEL = preload("uid://bj4lwbxdk6ctk")

@onready var left: Button = $Left
@onready var right: Button = $Right
@onready var back: Button = $Back
@onready var carouse_container: CarouseContainer = $CarouseContainer
@onready var panel_container: Control = $CarouseContainer/PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Start")
	for key in GlobalResourceLoader.weapon_cache.keys():
		var panel_node : WeaponSelectPanel = WEAPON_SELECT_PANEL.instantiate()
		panel_node.weapon_resource = GlobalResourceLoader.weapon_cache[key]
		panel_container.add_child(panel_node)
		if panel_node.weapon_resource.Id != "NewWorld":
			panel_node.is_lock = true
		
	for node in panel_container.get_children():
		var panel : WeaponSelectPanel = node as WeaponSelectPanel
		panel.button.pressed.connect(_on_panel_button_pressed)

func _on_panel_button_pressed() -> void:
	animation_player.play("End")
	for node in panel_container.get_children():
		var panel : WeaponSelectPanel = node as WeaponSelectPanel
		panel.button.disabled = true

func _on_left_pressed() -> void:
	carouse_container.left()

func _on_right_pressed() -> void:
	carouse_container.right()

func _on_back_pressed() -> void:
	queue_free()
