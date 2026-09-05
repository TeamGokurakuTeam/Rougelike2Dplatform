extends Component
class_name TrapComponent

signal trap_enabled()
signal trap_disabled()

@export var always_active : bool = false
@export var is_active : bool = true :
	set(value):
		if always_active and value == false:
			return
		if is_active == value:	# enable_trap / disable_trap 誤作動しないため
			return

		is_active = value
		_trigger_trap()

func setup(host: ComponentHost) -> void:
	super(host)
	if always_active:
		is_active = true
	_trigger_trap()

func _trigger_trap() -> void:
	if is_active:
		enable_trap()
	else:
		disable_trap()

func enable_trap() -> void:
	trap_enabled.emit()

func disable_trap() -> void:
	trap_disabled.emit()
