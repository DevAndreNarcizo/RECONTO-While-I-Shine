class_name EncantoSaltitante
extends EncantoBase
## SALTITANTE — projétil que voa até o inimigo mais próximo e QUICA para o
## próximo a cada acerto. (Pedra do Saci.) Projéteis geridos em lote aqui
## (arrays de dicionários — sem nós extras, pooling implícito).

const PROJ_SPEED := 280.0
const BOUNCE_RANGE := 240.0
const HIT_DISTANCE := 12.0
const BASE_BOUNCES := 3  # + nível = quiques totais

var _projectiles: Array[Dictionary] = []

func _attack() -> void:
	var targets := _nearest_enemies(player.global_position, amount())
	for t in targets:
		_projectiles.push_back({
			"pos": player.global_position,
			"target": t,
			"bounces": BASE_BOUNCES + level,
			"hit": [],
		})

func _physics_process(delta: float) -> void:
	super(delta)
	if _projectiles.is_empty():
		return
	var alive: Array[Dictionary] = []
	for p in _projectiles:
		if _step_projectile(p, delta):
			alive.push_back(p)
	_projectiles = alive
	queue_redraw()

## Retorna false quando o projétil termina.
func _step_projectile(p: Dictionary, delta: float) -> bool:
	var target: Enemy = p["target"]
	if not _is_valid_target(target):
		target = _retarget(p)
		if target == null:
			return false
		p["target"] = target
	p["pos"] = (p["pos"] as Vector2).move_toward(target.global_position, PROJ_SPEED * delta)
	if (p["pos"] as Vector2).distance_to(target.global_position) <= HIT_DISTANCE:
		target.take_damage(damage(), p["pos"])
		(p["hit"] as Array).push_back(target.get_instance_id())
		p["bounces"] = int(p["bounces"]) - 1
		if int(p["bounces"]) <= 0:
			return false
		var next := _retarget(p)
		if next == null:
			return false
		p["target"] = next
	return true

func _is_valid_target(e: Enemy) -> bool:
	return e != null and is_instance_valid(e) and e.visible and e.hp > 0.0 \
		and e.charmed_t <= 0.0  # nunca quica em aliados encantados

func _retarget(p: Dictionary) -> Enemy:
	var pos: Vector2 = p["pos"]
	var hit: Array = p["hit"]
	var best: Enemy = null
	var best_d := BOUNCE_RANGE * BOUNCE_RANGE
	for e in EnemySpawner.active_enemies():
		if not _is_valid_target(e) or hit.has(e.get_instance_id()):
			continue
		var d := pos.distance_squared_to(e.global_position)
		if d < best_d:
			best_d = d
			best = e
	return best

func _nearest_enemies(from: Vector2, count: int) -> Array[Enemy]:
	var enemies := EnemySpawner.active_enemies().duplicate()
	enemies.sort_custom(func(a, b):
		return from.distance_squared_to(a.global_position) < from.distance_squared_to(b.global_position))
	var result: Array[Enemy] = []
	for e in enemies:
		if _is_valid_target(e):
			result.push_back(e)
			if result.size() >= count:
				break
	return result

func _draw() -> void:
	for p in _projectiles:
		var local := to_local(p["pos"])
		draw_circle(local, 6.0, Color(0.55, 0.5, 0.45))
		draw_circle(local, 3.0, Color(0.75, 0.7, 0.6))
