class_name RainLayer
extends Node2D
## Chuva da Amazônia — visual em lote (um nó, sem partículas instanciadas).
## O efeito mecânico (projéteis -15%) é aplicado via GameState.projectile_env_mult.

const COUNT := 70
const AREA := Vector2(1200, 760)  # cobre a visão (zoom 2x) com folga
const FALL := Vector2(-60.0, 340.0)

var target: Node2D

var _drops: Array[Vector2] = []  # offsets relativos ao alvo

func _ready() -> void:
	z_index = 40
	for i in COUNT:
		_drops.push_back(Vector2(randf_range(-AREA.x, AREA.x), randf_range(-AREA.y, AREA.y)) / 2.0)

func _process(delta: float) -> void:
	if target == null:
		return
	for i in _drops.size():
		var d := _drops[i] + FALL * delta
		if d.y > AREA.y / 2.0:
			d = Vector2(randf_range(-AREA.x, AREA.x) / 2.0, -AREA.y / 2.0)
		_drops[i] = d
	queue_redraw()

func _draw() -> void:
	if target == null:
		return
	var center := to_local(target.global_position)
	for d in _drops:
		var pos := center + d
		draw_line(pos, pos + Vector2(-3.0, 12.0), Color(0.62, 0.72, 0.9, 0.35), 1.5)
