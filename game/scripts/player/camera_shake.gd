extends Camera2D
## Screen shake leve via EventBus.screen_shake(strength). Decai sozinho.

var _strength := 0.0

func _ready() -> void:
	EventBus.screen_shake.connect(_on_shake)

func _on_shake(strength: float) -> void:
	_strength = maxf(_strength, strength)

func _process(delta: float) -> void:
	if _strength > 0.05:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _strength
		_strength = lerpf(_strength, 0.0, 9.0 * delta)
	elif offset != Vector2.ZERO:
		offset = Vector2.ZERO
