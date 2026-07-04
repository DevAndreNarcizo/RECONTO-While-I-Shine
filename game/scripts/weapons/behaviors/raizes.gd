class_name EncantoRaizes
extends EncantoBase
## Forma ancestral RAIZES — Cipó da Mãe-da-Mata: raízes brotam do chão em
## posições aleatórias ao redor do player (Ritual: Cipó máx + Figa).

const SPAWN_RANGE := 420.0
const ROOT_RADIUS := 36.0
const VISUAL_TIME := 0.3

var _roots: Array[Dictionary] = []

func _attack() -> void:
	for i in amount():
		var pos := player.global_position + Vector2.from_angle(randf() * TAU) * randf_range(60.0, SPAWN_RANGE)
		damage_circle(pos, ROOT_RADIUS * area(), damage())
		_roots.push_back({"pos": pos, "t": VISUAL_TIME})
	queue_redraw()

func _process(delta: float) -> void:
	if _roots.is_empty():
		return
	for r in _roots:
		r["t"] = float(r["t"]) - delta
	_roots = _roots.filter(func(r): return float(r["t"]) > 0.0)
	queue_redraw()

func _draw() -> void:
	for r in _roots:
		var base := to_local(r["pos"])
		var alpha: float = clampf(float(r["t"]) / VISUAL_TIME, 0.0, 1.0)
		var color := Color(0.3, 0.65, 0.3, alpha)
		# leque de espinhos brotando do chão
		for i in 5:
			var ang := -PI / 2.0 + (i - 2) * 0.35
			var tip := base + Vector2.from_angle(ang) * ROOT_RADIUS * area()
			draw_line(base, tip, color, 4.0)
		draw_circle(base, 6.0, color)
