extends Node

enum InputMode {
	MOUSE,
	CONTROLLER
}

@export_category("コントローラーの初期設定")
@export var stick_deadzone : float = 0.2

signal device_changed(input_mode: InputMode)

var current_input_mode : InputMode = InputMode.MOUSE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		_set_device(InputMode.MOUSE)
	elif event is InputEventJoypadButton:
		_set_device(InputMode.CONTROLLER)
	elif event is InputEventJoypadMotion:
		if absf(event.axis_value) > stick_deadzone:
			_set_device(InputMode.CONTROLLER)

func _set_device(device: InputMode) -> void:
	if current_input_mode == device:
		return
	current_input_mode = device
	device_changed.emit(device)
