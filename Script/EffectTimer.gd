extends Timer
class_name EffectTimer

signal ticked(effect_type: Common.EffectType, damage: float)
signal expired(effect_type: Common.EffectType)

var effect_type: Common.EffectType = Common.EffectType.None
var damage_per_tick: float = 0.0

var _duration_timer: Timer

func setup(type: Common.EffectType, dps: float, duration: float) -> void:
	effect_type = type
	damage_per_tick = dps

	one_shot = false
	wait_time = 1.0
	timeout.connect(func() -> void: ticked.emit(effect_type, damage_per_tick))
	start()

	_duration_timer = Timer.new()
	_duration_timer.one_shot = true
	_duration_timer.timeout.connect(_on_duration_timeout)
	add_child(_duration_timer)
	_duration_timer.start(duration)

func refresh(new_damage_per_tick: float, new_duration: float) -> void:
	damage_per_tick = new_damage_per_tick
	_duration_timer.start(new_duration)

func _on_duration_timeout() -> void:
	expired.emit(effect_type)
	queue_free()