class_name Common

const UP_MASK : int = 0b0001
const DOWN_MASK : int = 0b0010
const LEFT_MASK : int = 0b0100
const RIGHT_MASK : int = 0b1000

static var debug_mode : bool = false

static func debug_print(msg : String) -> void:
	if debug_mode == true:
		print("[DEBUG][%s] %s " % [Time.get_datetime_string_from_system(), msg])