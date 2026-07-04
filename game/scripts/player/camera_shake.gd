extends Camera2D
## Câmera do player: zoom ajustável pelo SCROLL do mouse (com limites e
## persistência no save) + screen shake leve via EventBus.screen_shake.

const ZOOM_MIN := 1.6   # mais longe (vê mais mapa)
const ZOOM_MAX := 3.6   # mais perto do personagem
const ZOOM_STEP := 0.2
const ZOOM_DEFAULT := 2.4
const ZOOM_SMOOTH := 10.0

var _target_zoom := ZOOM_DEFAULT
var _strength := 0.0

func _ready() -> void:
	EventBus.screen_shake.connect(_on_shake)
	_target_zoom = clampf(float(SaveManager.settings.get("zoom", ZOOM_DEFAULT)), ZOOM_MIN, ZOOM_MAX)
	zoom = Vector2.ONE * _target_zoom

func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb == null or not mb.pressed:
		return
	if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
		_set_zoom(_target_zoom + ZOOM_STEP)
	elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		_set_zoom(_target_zoom - ZOOM_STEP)

func _set_zoom(value: float) -> void:
	_target_zoom = clampf(value, ZOOM_MIN, ZOOM_MAX)
	SaveManager.set_setting("zoom", _target_zoom)

func _process(delta: float) -> void:
	if not zoom.is_equal_approx(Vector2.ONE * _target_zoom):
		zoom = zoom.lerp(Vector2.ONE * _target_zoom, ZOOM_SMOOTH * delta)
	if _strength > 0.05:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _strength
		_strength = lerpf(_strength, 0.0, 9.0 * delta)
	elif offset != Vector2.ZERO:
		offset = Vector2.ZERO

func _on_shake(strength: float) -> void:
	_strength = maxf(_strength, strength)
