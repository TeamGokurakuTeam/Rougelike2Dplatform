class_name Common

const UP_MASK : int = 0b0001
const DOWN_MASK : int = 0b0010
const LEFT_MASK : int = 0b0100
const RIGHT_MASK : int = 0b1000

const TRANSITION_SCENE : PackedScene = preload("uid://dgjy5a68qdv5c")

static var debug_mode : bool = false
static var _current_transition_overlay : ColorRect = null

static func debug_print(msg : String) -> void:
	if debug_mode == true:
		print("[DEBUG][%s] %s " % [Time.get_datetime_string_from_system(), msg])

static func error_print(msg : String) -> void:
	print("[ERROR][%s] %s " % [Time.get_datetime_string_from_system(), msg])

# 画面を黒にトランジションする
static func fade_out_to_black(tree : SceneTree, duration : float = 0.8) -> void:
	var overlay : ColorRect = TRANSITION_SCENE.instantiate()

	# ColorRectを表示させるためにCanvasLayerを追加
	var layer := CanvasLayer.new()
	layer.layer = 4096
	layer.add_child(overlay)
	# current_sceneではなくrootに追加することで別のシーンに移動してもqueue_freeされない
	tree.root.add_child(layer)
	_current_transition_overlay = overlay

	var mat := overlay.material as ShaderMaterial
	mat.set_shader_parameter("progress", 0.0)
	var tween := layer.create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(mat, "shader_parameter/progress", 0.5, duration)
	await tween.finished

# 画面を黒からトランジションする
static func fade_in_from_black(duration : float = 0.8) -> void:
	var overlay : ColorRect = _current_transition_overlay
	if overlay == null:
		return
	_current_transition_overlay = null

	var layer : Node = overlay.get_parent()
	var tree : SceneTree = layer.get_tree()
	await tree.process_frame

	var mat : ShaderMaterial = overlay.material as ShaderMaterial
	var tween : Tween = layer.create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(mat, "shader_parameter/progress", 1.0, duration)
	await tween.finished
	layer.queue_free()

# 一瞬だけ画面黒くしてトランジションする
static func flash_transition(tree : SceneTree, duration : float = 1.2) -> void:
	const pause_duration : float = 0.2
	var transition_duration : float = (duration - pause_duration) / 2.0
	await fade_out_to_black(tree, transition_duration)
	await tree.create_timer(pause_duration).timeout
	await fade_in_from_black(transition_duration)
