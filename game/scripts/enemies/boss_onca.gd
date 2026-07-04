class_name BossOnca
extends Enemy
## Boss da Mata Atlântica — ONÇA CORROMPIDA (docs/06 §6).
## F1: circula e dá botes telegrafados (sombra no chão).
## F2 (≤50% HP): some nas sombras e reaparece; invoca enxame.
## F3 (≤20% HP): fúria — botes duplos, mais rápida.
## Derrotá-la = vitória do bioma (EventBus.boss_defeated).

const DATA := preload("res://resources/enemies/onca_corrompida.tres")
const CIRCLE_DIST := 240.0
const CIRCLE_SPEED := 90.0
const CIRCLE_TIME := 2.0
const TELEGRAPH_TIME := 0.8
const CHAIN_TELEGRAPH_TIME := 0.45
const POUNCE_SPEED := 520.0
const LAND_RADIUS := 56.0
const LAND_DAMAGE := 16.0
const REST_TIME := 1.4
const VANISH_TIME := 1.0

enum State { CIRCLE, TELEGRAPH, POUNCE, REST, VANISH }

var player: Player

var _state := State.CIRCLE
var _t := CIRCLE_TIME
var _mark := Vector2.ZERO
var _pounces_left := 0
var _phase := 1
var _orbit_sign := 1.0

func _ready() -> void:
	setup(DATA, global_position)

func take_damage(amount: float, from := Vector2.INF) -> void:
	super(amount, from)
	if hp <= 0.0:
		return
	if _phase == 1 and hp <= data.max_hp * 0.5:
		_phase = 2
		EnemySpawner.spawn_burst(&"firefly", 8)  # ruge e chama o enxame
		EventBus.screen_shake.emit(6.0)
	elif _phase == 2 and hp <= data.max_hp * 0.2:
		_phase = 3
		speed *= 1.3
		EventBus.screen_shake.emit(8.0)

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EventBus.screen_shake.emit(10.0)
	EventBus.boss_defeated.emit()  # vitória do bioma
	queue_free()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	_t -= delta
	match _state:
		State.CIRCLE:
			_orbit(delta)
			if _t <= 0.0:
				_pounces_left = 2 if _phase == 3 else 1
				_begin_telegraph(TELEGRAPH_TIME)
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_state = State.POUNCE
		State.POUNCE:
			set_move_dir(_mark - global_position)
			global_position = global_position.move_toward(_mark, POUNCE_SPEED * delta)
			if global_position.distance_squared_to(_mark) < 100.0:
				_land()
		State.REST:
			if _t <= 0.0:
				if _phase >= 2 and randf() < 0.5:
					_begin_vanish()
				else:
					_enter(State.CIRCLE, CIRCLE_TIME)
		State.VANISH:
			if _t <= 0.0:
				modulate.a = 1.0
				_orbit_sign = -_orbit_sign
				_enter(State.CIRCLE, CIRCLE_TIME * 0.5)

func _orbit(delta: float) -> void:
	var to_player := player.global_position - global_position
	var tangent := to_player.orthogonal().normalized() * _orbit_sign
	var radial := to_player.normalized() * clampf((to_player.length() - CIRCLE_DIST) * 0.02, -1.0, 1.0)
	var dir := (tangent + radial).normalized()
	set_move_dir(dir)
	global_position += dir * CIRCLE_SPEED * delta

func _begin_telegraph(time: float) -> void:
	_mark = player.global_position  # a sombra marca onde o bote vai cair
	_enter(State.TELEGRAPH, time)

func _begin_vanish() -> void:
	modulate.a = 0.15
	global_position = player.global_position + Vector2.from_angle(randf() * TAU) * CIRCLE_DIST
	_enter(State.VANISH, VANISH_TIME)

func _land() -> void:
	EventBus.screen_shake.emit(4.0)
	if player.global_position.distance_to(global_position) < LAND_RADIUS:
		player.take_damage(LAND_DAMAGE)
	_pounces_left -= 1
	if _pounces_left > 0:
		_begin_telegraph(CHAIN_TELEGRAPH_TIME)  # bote encadeado (F3)
	else:
		_enter(State.REST, REST_TIME)

func _enter(state: State, time: float) -> void:
	_state = state
	_t = time
	queue_redraw()

func _draw() -> void:
	super()
	# manchas da onça (placeholder com personalidade — só sem sprite)
	if data and _textures.is_empty():
		draw_circle(Vector2(-7, -5), 3.0, Color(0.3, 0.2, 0.05))
		draw_circle(Vector2(6, 3), 3.0, Color(0.3, 0.2, 0.05))
		draw_circle(Vector2(-2, 9), 2.5, Color(0.3, 0.2, 0.05))
	if _state == State.TELEGRAPH:
		# sombra do bote no chão — o aviso que ensina o jogador a ler ataques
		var local_mark := to_local(_mark)
		draw_circle(local_mark, LAND_RADIUS, Color(0, 0, 0, 0.3))
		draw_arc(local_mark, LAND_RADIUS, 0, TAU, 24, Color(1, 0.3, 0.2, 0.8), 3.0)
