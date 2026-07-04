class_name BossMapinguari
extends Enemy
## Boss da Amazônia — MAPINGUARI (docs/04 §4).
## F1: caminhada pesada + RUGIDO telegrafado que fere e empurra.
## F2 (≤55%): a boca-na-barriga cospe CONE de projéteis + invoca enxames.
## F3 (≤25%): tempestade — mais rápido, rugido maior, cone mais denso.

const DATA := preload("res://resources/enemies/mapinguari.tres")
const WALK_TIME := 2.6
const ROAR_TELEGRAPH := 1.0
const ROAR_RADIUS := 190.0
const ROAR_DAMAGE := 14.0
const ROAR_PUSH := 620.0
const CONE_SPREAD := 0.35
const REST_TIME := 1.1

enum State { WALK, ROAR, REST }

var player: Player

var _state := State.WALK
var _t := WALK_TIME
var _phase := 1

func _ready() -> void:
	setup(DATA, global_position)

func take_damage(amount: float, from := Vector2.INF) -> void:
	super(amount, from)
	if hp <= 0.0:
		return
	if _phase == 1 and hp <= data.max_hp * 0.55:
		_phase = 2
		EnemySpawner.spawn_burst(&"mosquito", 8)
		EventBus.screen_shake.emit(6.0)
	elif _phase == 2 and hp <= data.max_hp * 0.25:
		_phase = 3
		speed *= 1.4
		EventBus.screen_shake.emit(9.0)

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EventBus.screen_shake.emit(10.0)
	EventBus.boss_defeated.emit()  # vitória do bioma
	queue_free()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var to_player := player.global_position - global_position
	_t -= delta
	match _state:
		State.WALK:
			set_move_dir(to_player)
			global_position += to_player.normalized() * speed * delta
			if _t <= 0.0:
				if _phase >= 2 and randf() < 0.5:
					_spit_cone(to_player.normalized())
				else:
					_state = State.ROAR
					_t = ROAR_TELEGRAPH
					queue_redraw()
		State.ROAR:
			queue_redraw()
			if _t <= 0.0:
				_roar(to_player)
		State.REST:
			if _t <= 0.0:
				_state = State.WALK
				_t = WALK_TIME / (1.5 if _phase == 3 else 1.0)
				queue_redraw()

func _roar_radius() -> float:
	return ROAR_RADIUS * (1.25 if _phase == 3 else 1.0)

func _roar(to_player: Vector2) -> void:
	EventBus.screen_shake.emit(7.0)
	if to_player.length() < _roar_radius():
		player.take_damage(ROAR_DAMAGE)
		player.external_push = to_player.normalized() * ROAR_PUSH
	_state = State.REST
	_t = REST_TIME
	queue_redraw()

func _spit_cone(dir: Vector2) -> void:
	var count := 5 if _phase == 3 else 3
	for i in count:
		var spread := (i - (count - 1) / 2.0) * CONE_SPREAD
		EnemySpawner.shoot(global_position, dir.rotated(spread), 9.0)
	_state = State.REST
	_t = REST_TIME
	queue_redraw()

func _draw() -> void:
	super()
	if _state == State.ROAR:
		# o rugido enche os pulmões — saia do raio antes do estouro
		var progress := 1.0 - clampf(_t / ROAR_TELEGRAPH, 0.0, 1.0)
		draw_arc(Vector2.ZERO, _roar_radius(), 0, TAU, 32, Color(1, 0.4, 0.2, 0.5 + 0.4 * progress), 3.0)
		draw_circle(Vector2.ZERO, _roar_radius() * progress, Color(1, 0.5, 0.2, 0.12))
