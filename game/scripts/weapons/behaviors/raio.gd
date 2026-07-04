class_name EncantoRaio
extends EncantoBase
## RAIO — relâmpago cai do céu sobre inimigos aleatórios, dano em pequena área.
## (Relâmpago do Trovão.) Placeholder: linha serrilhada branca + clarão.

const STRIKE_RADIUS := 42.0
const VISUAL_TIME := 0.22

var _strikes: Array[Dictionary] = []  # {pos: Vector2 global, t: float}

func _attack() -> void:
	var hostiles: Array[Enemy] = []
	for e in EnemySpawner.active_enemies():
		if e.charmed_t <= 0.0 and e.hp > 0.0 and e.visible:
			hostiles.push_back(e)
	if hostiles.is_empty():
		return
	for i in amount():
		var target: Enemy = hostiles.pick_random()
		if target == null:
			continue
		var pos := target.global_position
		damage_circle(pos, STRIKE_RADIUS * area(), damage())
		_strikes.push_back({"pos": pos, "t": VISUAL_TIME})
	queue_redraw()

func _process(delta: float) -> void:
	if _strikes.is_empty():
		return
	var alive: Array[Dictionary] = []
	for s in _strikes:
		s["t"] = float(s["t"]) - delta
		if float(s["t"]) > 0.0:
			alive.push_back(s)
	_strikes = alive
	queue_redraw()

func _draw() -> void:
	for s in _strikes:
		var base := to_local(s["pos"])
		var alpha: float = clampf(float(s["t"]) / VISUAL_TIME, 0.0, 1.0)
		var bolt := Color(0.85, 0.92, 1.0, alpha)
		# raio serrilhado descendo do "céu"
		var points := PackedVector2Array([
			base + Vector2(6, -180), base + Vector2(-8, -120),
			base + Vector2(10, -70), base + Vector2(-4, -30), base,
		])
		draw_polyline(points, bolt, 3.0)
		draw_circle(base, STRIKE_RADIUS * area() * alpha, Color(1, 1, 0.8, 0.25 * alpha))
