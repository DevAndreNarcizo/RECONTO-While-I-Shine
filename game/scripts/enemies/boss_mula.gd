class_name BossMula
extends Enemy
## Boss da Caatinga — MULA-SEM-CABEÇA (docs/06 §6).
## F1: galopes em linha reta atravessando a arena, deixando TRILHA DE FOGO.
## F2 (≤50%): galopes mais rápidos; ao parar, coice abre explosão radial.
## F3 (≤20%): para de correr — "chora fogo": explosões radiais lentas e enormes.
## (A F3 é a memória voltando — ela é prisioneira, não vilã. Vencer = redimir.)

const DATA := preload("res://resources/enemies/mula_sem_cabeca.tres")
const TELEGRAPH_TIME := 0.8
const GALLOP_SPEED := 520.0
const GALLOP_DIST := 620.0
const REST_TIME := 1.4
const FIRE_STEP := 40.0            # espaçamento das chamas na trilha
const KICK_RADIUS := 120.0
const KICK_DAMAGE := 18.0
const CRY_INTERVAL := 1.6
const CRY_RADIUS := 200.0
const CRY_DAMAGE := 22.0

enum State { CHASE, TELEGRAPH, GALLOP, REST, CRY }

var player: Player

var _state := State.CHASE
var _t := 1.5
var _target := Vector2.ZERO
var _last_fire := Vector2.ZERO
var _phase := 1

func _ready() -> void:
	setup(DATA, global_position)

func take_damage(amount: float, from := Vector2.INF) -> void:
	super(amount, from)
	if hp <= 0.0:
		return
	if _phase == 1 and hp <= data.max_hp * 0.5:
		_phase = 2
		speed *= 1.25
		EventBus.screen_shake.emit(6.0)
	elif _phase == 2 and hp <= data.max_hp * 0.2:
		_phase = 3
		_state = State.CRY
		_t = CRY_INTERVAL
		EventBus.screen_shake.emit(9.0)

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EventBus.screen_shake.emit(10.0)
	EventBus.boss_defeated.emit()  # vitória do bioma — a Mula é redimida
	queue_free()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	_t -= delta
	match _state:
		State.CHASE:
			set_move_dir(player.global_position - global_position)
			global_position += (player.global_position - global_position).normalized() * speed * 0.4 * delta
			if _t <= 0.0:
				_target = global_position + (player.global_position - global_position).normalized() * GALLOP_DIST
				_last_fire = global_position
				_state = State.TELEGRAPH
				_t = TELEGRAPH_TIME
				queue_redraw()
		State.TELEGRAPH:
			queue_redraw()
			if _t <= 0.0:
				_state = State.GALLOP
				EventBus.screen_shake.emit(3.0)
		State.GALLOP:
			set_move_dir(_target - global_position)
			global_position = global_position.move_toward(_target, GALLOP_SPEED * delta)
			if global_position.distance_to(_last_fire) >= FIRE_STEP:
				EventBus.fire_started.emit(global_position)  # trilha de fogo (bioma reativo)
				_last_fire = global_position
			if global_position.distance_squared_to(_target) < 100.0:
				_end_gallop()
		State.REST:
			if _t <= 0.0:
				_state = State.CHASE
				_t = 1.0
		State.CRY:
			if _t <= 0.0:
				_cry()

func _end_gallop() -> void:
	if _phase >= 2:
		# coice: explosão radial ao parar
		EventBus.screen_shake.emit(4.0)
		if player.global_position.distance_to(global_position) < KICK_RADIUS:
			player.take_damage(KICK_DAMAGE)
	_state = State.REST
	_t = REST_TIME
	queue_redraw()

func _cry() -> void:
	# F3: chora fogo — explosão radial enorme e lenta
	EventBus.screen_shake.emit(6.0)
	EventBus.ability_cast.emit(global_position, CRY_RADIUS)
	if player.global_position.distance_to(global_position) < CRY_RADIUS:
		player.take_damage(CRY_DAMAGE)
	for i in 8:
		EventBus.fire_started.emit(global_position + Vector2.from_angle(TAU * i / 8.0) * CRY_RADIUS * 0.6)
	_t = CRY_INTERVAL

func _draw() -> void:
	super()
	if _state == State.TELEGRAPH:
		draw_line(Vector2.ZERO, to_local(_target), Color(1, 0.3, 0.15, 0.7), 5.0)
	elif _state == State.CRY:
		draw_arc(Vector2.ZERO, CRY_RADIUS, 0, TAU, 32, Color(1, 0.45, 0.15, 0.5), 3.0)
