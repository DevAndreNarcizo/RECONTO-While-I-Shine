extends Node
## EnemySpawner — object pooling de inimigos, spawn em anel fora da tela
## e movimento em LOTE (um único loop, sem _process por inimigo).

const ENEMY_SCENE := preload("res://scenes/enemies/Enemy.tscn")
# Meia diagonal visível (zoom 2x): ~551 px. Spawna um pouco além, fora da visão.
const SPAWN_RADIUS := 640.0
const MAX_ACTIVE := 600

var spawn_rate := 2.0  # inimigos por segundo (curva de dificuldade mexe aqui)
var default_data: EnemyData = preload("res://resources/enemies/swarm_firefly.tres")

var _pool: Array[Enemy] = []
var _active: Array[Enemy] = []
var _accum := 0.0
var _player: Node2D
var _container: Node
var _running := false

func start(player: Node2D, container: Node = null) -> void:
	_player = player
	_container = container if container else self
	_running = true

func stop() -> void:
	_running = false
	for e in _active.duplicate():
		despawn(e)

## Esquece pool e referências SEM liberar nós — usar antes de recarregar a cena
## (os inimigos vivem dentro dela e são liberados junto).
func reset() -> void:
	_running = false
	_active.clear()
	_pool.clear()
	_player = null
	_container = null
	_accum = 0.0

func active_count() -> int:
	return _active.size()

func active_enemies() -> Array[Enemy]:
	return _active

func _physics_process(delta: float) -> void:
	if not _running or _player == null:
		return

	_accum += delta * spawn_rate
	while _accum >= 1.0 and _active.size() < MAX_ACTIVE:
		_accum -= 1.0
		_spawn_one()

	# Movimento em lote: perseguição simples + knockback decaindo
	var target := _player.global_position
	for e in _active:
		var motion := (target - e.global_position).normalized() * e.speed + e.knockback
		e.global_position += motion * delta
		if e.knockback != Vector2.ZERO:
			e.knockback = e.knockback.move_toward(Vector2.ZERO, 420.0 * delta)

func _spawn_one() -> void:
	var e := _get_from_pool()
	var pos := _player.global_position + Vector2.from_angle(randf() * TAU) * SPAWN_RADIUS
	e.setup(default_data, pos)
	_active.push_back(e)

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
