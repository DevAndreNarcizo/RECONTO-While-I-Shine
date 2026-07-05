class_name EncantoMeleeGiro
extends EncantoBase
## MELEE_GIRO — Garras Lunares: golpe giratório 360° ao redor do player.
## A arma do Lobisomem: +50% de dano na Lua Cheia (lê o Ciclo da Lua).

const RADIUS := 70.0
const VISUAL_TIME := 0.2

var _visual_t := 0.0
var _spin := 0.0

func _attack() -> void:
	var moon_mult := 1.5 if MoonCycleManager.is_full_moon() else 1.0
	damage_circle(player.global_position, RADIUS * area(), damage() * moon_mult)
	_visual_t = VISUAL_TIME
	_spin = randf() * TAU
	queue_redraw()

func _process(delta: float) -> void:
	if _visual_t > 0.0:
		_visual_t -= delta
		queue_redraw()

func _draw() -> void:
	if _visual_t <= 0.0:
		return
	var alpha: float = clampf(_visual_t / VISUAL_TIME, 0.0, 1.0)
	var color := Color(0.75, 0.82, 1.0, alpha)  # prata-lunar
	for i in 3:
		var start := _spin + TAU * i / 3.0
		draw_arc(Vector2.ZERO, RADIUS * area(), start, start + 1.4, 10, color, 4.0)
