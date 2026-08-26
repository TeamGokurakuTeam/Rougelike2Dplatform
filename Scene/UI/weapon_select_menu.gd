extends Control
class_name WeaponSelectMenu

const WEAPON_SELECT_PANEL = preload("uid://bj4lwbxdk6ctk")

@onready var left: Button = $Left
@onready var right: Button = $Right
@onready var back: Button = $Back
@onready var carouse_container: CarouseContainer = $CarouseContainer
@onready var panel_container: Control = $CarouseContainer/PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var title : TitleUI
var main_game_scene : PackedScene

func _ready() -> void:
	animation_player.play("Start")
	main_game_scene = load("uid://b4i3w233507yf")
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
	for node in panel_container.get_children():
		var panel : WeaponSelectPanel = node as WeaponSelectPanel
		panel.button.disabled = true
	var start_tween : Tween = create_tween()
	start_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	start_tween.tween_property(title.audio_stream_player, "volume_db", -80, 0.5)
	await start_tween.finished
	animation_player.play("End")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(main_game_scene)

func _on_left_pressed() -> void:
	carouse_container.left()

func _on_right_pressed() -> void:
	carouse_container.right()

func _on_back_pressed() -> void:
	queue_free()
