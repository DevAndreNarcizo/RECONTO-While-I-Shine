extends Node
## EnemySpawner — object pooling, curva de spawn por fase da run (Balance),
## ondas temáticas, movimento em LOTE por comportamento e projéteis inimigos.

const ENEMY_SCENE := preload("res://scenes/enemies/Enemy.tscn")
const PROJECTILE_SCENE := preload("res://scenes/enemies/EnemyProjectile.tscn")
# Meia diagonal visível (zoom 2x): ~551 px. Spawna um pouco além, fora da visão.
const SPAWN_RADIUS := 640.0
const MAX_ACTIVE := 600
const SHOOT_RANGE := 360.0
const ZIGZAG_FREQ := 3.0
const ZIGZAG_AMP := 0.6

const TYPES := {
	&"firefly": preload("res://resources/enemies/swarm_firefly.tres"),
	&"cutia": preload("res://resources/enemies/cutia_oca.tres"),
	&"macaco": preload("res://resources/enemies/macaco_prego.tres"),
	&"sapo": preload("res://resources/enemies/sapo_cururu.tres"),
	&"tamandua": preload("res://resources/enemies/tamandua_casca_grossa.tres"),
	&"elite": preload("res://resources/enemies/elite_corrompido.tres"),
	# Amazônia
	&"formigao": preload("res://resources/enemies/formigao_correicao.tres"),
	&"mosquito": preload("res://resources/enemies/mosquito_praga.tres"),
	&"jacare": preload("res://resources/enemies/jacare_acu.tres"),
	&"tatu": preload("res://resources/enemies/tatu_canastra.tres"),
}

var spawn_table: Array = Balance.MATA_SPAWN_TABLE

var _pool: Array[Enemy] = []
var _active: Array[Enemy] = []
var _proj_pool: Array[EnemyProjectile] = []
var _proj_active: Array[EnemyProjectile] = []
var _accum := 0.0
var _wave_accum := 0.0
var _player: Node2D
var _container: Node
var _running := false

func start(player: Node2D, container: Node = null, table: Array = Balance.MATA_SPAWN_TABLE) -> void:
	_player = player
	_container = container if container else self
	spawn_table = table
	_wave_accum = 0.0
	_running = true

func stop() -> void:
	_running = false
	for e in _active.duplicate():
		despawn(e)

## Esquece pool e referências SEM liberar nós — usar antes de recarregar/trocar
## a cena (os inimigos vivem dentro dela e são liberados junto).
func reset() -> void:
	_running = false
	_active.clear()
	_pool.clear()
	_proj_active.clear()
	_proj_pool.clear()
	_player = null
	_container = null
	_accum = 0.0
	_wave_accum = 0.0

func active_count() -> int:
	return _active.size()

func active_enemies() -> Array[Enemy]:
	return _active

## Spawn direto (bosses usam para invocar reforços).
func spawn_burst(type_key: StringName, count: int) -> void:
	if not _running:
		return
	for i in count:
		_spawn_one(TYPES[type_key], TAU * i / count)

func _physics_process(delta: float) -> void:
	if not _running or _player == null:
		return

	var phase := _current_phase()
	_accum += delta * float(phase["rate"]) * MoonCycleManager.spawn_mult()
	while _accum >= 1.0 and _active.size() < MAX_ACTIVE:
		_accum -= 1.0
		_spawn_one(_pick_type(phase["weights"]))

	_wave_accum += delta
	if _wave_accum >= Balance.WAVE_INTERVAL_FRAC * Balance.run_duration():
		_wave_accum = 0.0
		_spawn_wave(_pick_type(phase["weights"]))

	_move_enemies(delta)
	_move_projectiles(delta)

func _run_frac() -> float:
	return clampf(GameState.run_time / Balance.run_duration(), 0.0, 1.0)

func _current_phase() -> Dictionary:
	var frac := _run_frac()
	var current: Dictionary = spawn_table[0]
	for phase in spawn_table:
		if frac >= float(phase["from"]):
			current = phase
	return current

func _pick_type(weights: Dictionary) -> EnemyData:
	var total := 0.0
	for w in weights.values():
		total += float(w)
	var pick := randf() * total
	for key in weights:
		pick -= float(weights[key])
		if pick <= 0.0:
			return TYPES[key]
	return TYPES[&"firefly"]

func _spawn_one(data: EnemyData, angle := -1.0) -> void:
	var e := _get_from_pool()
	var a := angle if angle >= 0.0 else randf() * TAU
	e.setup(data, _player.global_position + Vector2.from_angle(a) * SPAWN_RADIUS)
	_active.push_back(e)

## Onda temática: um anel do mesmo tipo cerca o player.
func _spawn_wave(data: EnemyData) -> void:
	for i in Balance.WAVE_COUNT:
		_spawn_one(data, TAU * i / Balance.WAVE_COUNT)

## Encanta um inimigo (inovação #2), respeitando o limite de aliados.
func charm_enemy(e: Enemy, duration: float) -> bool:
	if e.charmed_t > 0.0 or e.hp <= 0.0:
		return false
	var count := 0
	for a in _active:
		if a.charmed_t > 0.0:
			count += 1
	if count >= Balance.CHARM_LIMIT:
		return false
	e.charm(duration)
	return true

func _nearest_hostile(pos: Vector2, max_range: float) -> Enemy:
	var best: Enemy = null
	var best_d := max_range * max_range
	for e in _active:
		if e.charmed_t > 0.0 or e.hp <= 0.0:
			continue
		var d := pos.distance_squared_to(e.global_position)
		if d < best_d:
			best_d = d
			best = e
	return best

func _move_enemies(delta: float) -> void:
	var target := _player.global_position
	for e in _active:
		var to_player := target - e.global_position
		var dir: Vector2
		if e.charmed_t > 0.0:
			e.charmed_t -= delta
			if e.charmed_t <= 0.0:
				e.uncharm()  # a Luz se esgotou: volta a ser hostil
				continue
			dir = _charmed_behavior(e, to_player, delta)
		elif e.confusion_t > 0.0:
			e.confusion_t -= delta
			if e.confusion_t <= 0.0:
				e.refresh_visual()  # tira o visual de confusão
			dir = e.confusion_dir
		else:
			match e.data.behavior:
				EnemyData.Behavior.ZIGZAG:
					var base := to_player.normalized()
					var wave := sin(GameState.run_time * ZIGZAG_FREQ + e.zig_phase)
					dir = (base + base.orthogonal() * wave * ZIGZAG_AMP).normalized()
				EnemyData.Behavior.SHOOTER:
					var dist := to_player.length()
					if dist > e.data.keep_distance + 40.0:
						dir = to_player.normalized()
					elif dist < e.data.keep_distance - 40.0:
						dir = -to_player.normalized()
					else:
						dir = to_player.orthogonal().normalized() * 0.4  # deriva lateral
					e.shoot_cd -= delta
					if e.shoot_cd <= 0.0 and dist <= SHOOT_RANGE:
						e.shoot_cd = e.data.shoot_interval
						_shoot(e.global_position, to_player.normalized(), e.data.projectile_damage)
				_:
					dir = to_player.normalized()
		e.set_move_dir(dir)  # vira o sprite para a direção do movimento
		e.global_position += (dir * e.speed + e.knockback) * delta
		if e.knockback != Vector2.ZERO:
			e.knockback = e.knockback.move_toward(Vector2.ZERO, 420.0 * delta)

## Aliado encantado: caça o hostil mais próximo; sem alvo, escolta o player.
func _charmed_behavior(e: Enemy, to_player: Vector2, delta: float) -> Vector2:
	e.charm_hit_cd = maxf(0.0, e.charm_hit_cd - delta)
	var foe := _nearest_hostile(e.global_position, 420.0)
	if foe:
		var to_foe := foe.global_position - e.global_position
		var reach := e.data.radius + foe.data.radius + 4.0
		if to_foe.length() <= reach and e.charm_hit_cd <= 0.0:
			e.charm_hit_cd = 0.5
			foe.take_damage(e.data.contact_damage * 1.5, e.global_position)
		return to_foe.normalized()
	# escolta: mantém ~70 px do player
	if to_player.length() > 70.0:
		return to_player.normalized()
	return Vector2.ZERO

func despawn(e: Enemy) -> void:
	var i := _active.find(e)
	if i == -1:
		return
	# swap-remove: O(1), a ordem do array não importa
	_active[i] = _active[_active.size() - 1]
	_active.pop_back()
	e.hide()
	e.set_deferred("monitorable", false)
	_pool.push_back(e)

func _get_from_pool() -> Enemy:
	if _pool.is_empty():
		var e: Enemy = ENEMY_SCENE.instantiate()
		_container.add_child(e)
		return e
	return _pool.pop_back()

# --- Projéteis inimigos (pooled, movidos em lote) ---

## Disparo público (bosses usam para cones/padrões próprios).
func shoot(pos: Vector2, dir: Vector2, damage: float) -> void:
	_shoot(pos, dir, damage)

func _shoot(pos: Vector2, dir: Vector2, damage: float) -> void:
	var p: EnemyProjectile
	if _proj_pool.is_empty():
		p = PROJECTILE_SCENE.instantiate()
		_container.add_child(p)
	else:
		p = _proj_pool.pop_back()
	p.launch(pos, dir, damage)
	_proj_active.push_back(p)

func _move_projectiles(delta: float) -> void:
	var i := 0
	while i < _proj_active.size():
		var p := _proj_active[i]
		p.global_position += p.dir * EnemyProjectile.SPEED * delta
		p.ttl -= delta
		if p.ttl <= 0.0:
			despawn_projectile(p)  # swap-remove: não incrementa o índice
		else:
			i += 1

func despawn_projectile(p: EnemyProjectile) -> void:
	var i := _proj_active.find(p)
	if i == -1:
		return
	_proj_active[i] = _proj_active[_proj_active.size() - 1]
	_proj_active.pop_back()
	p.hide()
	p.set_deferred("monitorable", false)
	_proj_pool.push_back(p)
