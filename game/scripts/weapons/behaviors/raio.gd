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
		EventBus.fire_started.emit(pos)  # raio incendeia a vegetação (bioma reativo)
		_strikes.push_back({"pos": pos, "t": VISUAL_TIME})
		_chain_from(pos, hostiles, target)
	queue_redraw()

## Tempestade (forma ancestral): o raio salta para vizinhos com 60% do dano.
func _chain_from(origin: Vector2, hostiles: Array[Enemy], first: Enemy) -> void:
	if data.chain <= 0:
		return
	const CHAIN_RANGE := 220.0
	var jumped := 0
	var last := origin
	for e in hostiles:
		if jumped >= data.chain:
			break
		if e == first or not is_instance_valid(e) or e.hp <= 0.0:
			continue
		if last.distance_squared_to(e.global_position) > CHAIN_RANGE * CHAIN_RANGE:
			continue
		damage_circle(e.global_position, STRIKE_RADIUS * 0.7, damage() * 0.6)
		_strikes.push_back({"pos": e.global_position, "t": VISUAL_TIME * 0.8, "link": last})
		last = e.global_position
		jumped += 1

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
		if s.has("link"):
			# arco em cadeia ligando ao alvo anterior (Tempestade)
			draw_line(to_local(s["link"]), base, bolt, 2.5)
		# raio serrilhado descendo do "céu"
		var points := PackedVector2Array([
			base + Vector2(6, -180), base + Vector2(-8, -120),
			base + Vector2(10, -70), base + Vector2(-4, -30), base,
		])
		draw_polyline(points, bolt, 3.0)
		draw_circle(base, STRIKE_RADIUS * area() * alpha, Color(1, 1, 0.8, 0.25 * alpha))
